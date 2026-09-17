[CmdletBinding()]
param(
  [string]$RepositoryRoot
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
  $RepositoryRoot = Split-Path -Parent $PSScriptRoot
}
$failures = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Add-Failure([string]$Message) { $script:failures.Add($Message) }
function Add-Warning([string]$Message) { $script:warnings.Add($Message) }

function Read-JsonFile([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Add-Failure "Missing JSON file: $Path"
    return $null
  }
  try {
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
  } catch {
    Add-Failure "Invalid JSON in ${Path}: $($_.Exception.Message)"
    return $null
  }
}

function Test-RequiredProperties($Object, [string[]]$Names, [string]$Context) {
  if ($null -eq $Object) { return }
  foreach ($name in $Names) {
    if (-not ($Object.PSObject.Properties.Name -contains $name)) {
      Add-Failure "$Context is missing required property '$name'."
    }
  }
}

function Get-RelativeLuminance([string]$Hex) {
  $raw = $Hex.TrimStart('#')
  $channels = @(0, 2, 4) | ForEach-Object {
    $value = [Convert]::ToInt32($raw.Substring($_, 2), 16) / 255.0
    if ($value -le 0.04045) { $value / 12.92 } else { [Math]::Pow((($value + 0.055) / 1.055), 2.4) }
  }
  return (0.2126 * $channels[0]) + (0.7152 * $channels[1]) + (0.0722 * $channels[2])
}

function Get-ContrastRatio([string]$A, [string]$B) {
  $la = Get-RelativeLuminance $A
  $lb = Get-RelativeLuminance $B
  $light = [Math]::Max($la, $lb)
  $dark = [Math]::Min($la, $lb)
  return ($light + 0.05) / ($dark + 0.05)
}

$seriesPath = Join-Path $RepositoryRoot 'series\series.json'
$series = Read-JsonFile $seriesPath
Test-RequiredProperties $series @('id','name','identity','audience','educational_purpose','language','design_system','policies','canva','visuals','locked_decisions') 'series.json'

$tokensPath = Join-Path $RepositoryRoot 'design-system\tokens.json'
$tokens = Read-JsonFile $tokensPath
Test-RequiredProperties $tokens @('name','version','palette_source','color','typography','spacing','grid','shape','iconography','motion') 'tokens.json'

if ($tokens) {
  $contrastPairs = @(
    @{ Name = 'ink on paper'; Foreground = $tokens.color.ink.value; Background = $tokens.color.paper.value; Minimum = 4.5 },
    @{ Name = 'white on ink'; Foreground = $tokens.color.white.value; Background = $tokens.color.ink.value; Minimum = 4.5 },
    @{ Name = 'blue on paper'; Foreground = $tokens.color.blue.value; Background = $tokens.color.paper.value; Minimum = 4.5 },
    @{ Name = 'muted on paper'; Foreground = $tokens.color.muted.value; Background = $tokens.color.paper.value; Minimum = 4.5 }
  )
  foreach ($pair in $contrastPairs) {
    $ratio = Get-ContrastRatio $pair.Foreground $pair.Background
    if ($ratio -lt $pair.Minimum) {
      Add-Failure ("Contrast {0} is {1:N2}:1; requires {2}:1." -f $pair.Name, $ratio, $pair.Minimum)
    }
  }
}

$visualSchema = Read-JsonFile (Join-Path $RepositoryRoot 'schemas\visual.schema.json')
$seriesSchema = Read-JsonFile (Join-Path $RepositoryRoot 'schemas\series.schema.json')
Test-RequiredProperties $visualSchema @('$schema','$id','type','required','properties') 'visual.schema.json'
Test-RequiredProperties $seriesSchema @('$schema','$id','type','required','properties') 'series.schema.json'

$currentYear = (Get-Date).Year
if ($series) {
  foreach ($visualRef in $series.visuals) {
    $visualPath = Join-Path (Join-Path $RepositoryRoot 'series') $visualRef.manifest
    $visual = Read-JsonFile $visualPath
    Test-RequiredProperties $visual @('id','title','subtitle','language','purpose','main_message','type','blocks','relationships','reading_order','canva_spec','interactive','accessibility','claims','sources','skill_links','status','urls') $visualRef.manifest
    if (-not $visual) { continue }

    $sourceIds = @($visual.sources | ForEach-Object { $_.id })
    $claimIds = @($visual.claims | ForEach-Object { $_.id })
    foreach ($claim in $visual.claims) {
      foreach ($sourceId in $claim.source_ids) {
        if ($sourceIds -notcontains $sourceId) { Add-Failure "Claim $($claim.id) refers to missing source $sourceId." }
      }
    }
    foreach ($source in $visual.sources) {
      foreach ($claimId in $source.supports_claims) {
        if ($claimIds -notcontains $claimId) { Add-Failure "Source $($source.id) refers to missing claim $claimId." }
      }
      if ($source.type -eq 'peer-reviewed-article') {
        if (-not $source.peer_reviewed) { Add-Failure "Academic source $($source.id) is not marked peer reviewed." }
        if (($currentYear - [int]$source.year) -gt [int]$series.policies.academic_source_window_years) {
          Add-Failure "Academic source $($source.id) is outside the $($series.policies.academic_source_window_years)-year window."
        }
        if (-not $source.doi) { Add-Warning "Academic source $($source.id) has no DOI." }
      }
    }
    foreach ($block in $visual.blocks) {
      foreach ($marker in $block.evidence_markers) {
        if ($sourceIds -notcontains $marker) { Add-Failure "Block $($block.id) uses missing evidence marker $marker." }
      }
    }
    if ($visual.reading_order.Count -ne $visual.blocks.Count) { Add-Failure "Reading order and block count differ in $($visual.id)." }
    if ($visual.urls.canva_public -and $visual.urls.canva_public -match '(edit|design/[^/]+/edit)') { Add-Failure "A possible private Canva edit URL appears in $($visual.id)." }
  }
}

$skillRoot = Join-Path $RepositoryRoot 'skills'
$skillDirs = Get-ChildItem -LiteralPath $skillRoot -Directory
foreach ($skillDir in $skillDirs) {
  $skillPath = Join-Path $skillDir.FullName 'SKILL.md'
  $agentPath = Join-Path $skillDir.FullName 'agents\openai.yaml'
  if (-not (Test-Path -LiteralPath $skillPath)) { Add-Failure "Missing SKILL.md for $($skillDir.Name)."; continue }
  if (-not (Test-Path -LiteralPath $agentPath)) { Add-Failure "Missing agents/openai.yaml for $($skillDir.Name)."; continue }
  $skillText = Get-Content -LiteralPath $skillPath -Raw -Encoding UTF8
  if ($skillText -notmatch "(?ms)^---\s*\r?\nname:\s*$([regex]::Escape($skillDir.Name))\s*\r?\ndescription:") {
    Add-Failure "Invalid or mismatched frontmatter for $($skillDir.Name)."
  }
  $yamlText = Get-Content -LiteralPath $agentPath -Raw -Encoding UTF8
  if ($yamlText -notmatch [regex]::Escape("`$$($skillDir.Name)")) { Add-Failure "Default prompt does not invoke `$$($skillDir.Name)." }
}

$visualHtmlPath = Join-Path $RepositoryRoot 'site\visual.html'
$visualHtml = Get-Content -LiteralPath $visualHtmlPath -Raw -Encoding UTF8
foreach ($required in @('id="overview"','id="frameworks"','id="technology"','id="evidence"','class="skip-link"','prefers-reduced-motion')) {
  if ($required -eq 'prefers-reduced-motion') { continue }
  if ($visualHtml -notmatch [regex]::Escape($required)) { Add-Failure "visual.html is missing $required." }
}
$styles = Get-Content -LiteralPath (Join-Path $RepositoryRoot 'site\assets\styles.css') -Raw -Encoding UTF8
if ($styles -notmatch 'prefers-reduced-motion') { Add-Failure 'The companion does not include reduced-motion CSS.' }
if ($visualHtml -match '<a\s+[^>]*href="#"') { Add-Failure 'The companion contains an empty hash link.' }

$trackedTextFiles = Get-ChildItem -LiteralPath $RepositoryRoot -Recurse -File | Where-Object { $_.Extension -in @('.json','.md','.html','.css','.js','.yml','.yaml','.ps1') }
foreach ($file in $trackedTextFiles) {
  $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
  if ($text -match 'canva\.com/design/[^\s"'']+/edit') { Add-Failure "Possible Canva edit URL in $($file.FullName)." }
  if ($text -match '(ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,})') { Add-Failure "Possible GitHub token in $($file.FullName)." }
}

foreach ($warning in $warnings) { Write-Warning $warning }
if ($failures.Count -gt 0) {
  foreach ($failure in $failures) { Write-Error $failure }
  throw "Validation failed with $($failures.Count) error(s)."
}

Write-Output "Validation passed: JSON parsed, required schema fields checked, claims mapped, sources current, skill packages valid, contrast pairs pass, and companion essentials present."
