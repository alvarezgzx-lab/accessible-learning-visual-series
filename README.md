# Accessible Learning Visual Series

An open system for creating evidence-informed educational visuals in Canva and publishing accessible, interactive companions on GitHub Pages.

## What this repository contains

- a reusable design system and five Canva layout families;
- a JSON source of truth for the series and every visual;
- an accessible HTML/SVG companion with linked evidence;
- one coordinating Codex skill and four focused mini-skills;
- validation scripts and a GitHub Pages workflow.

The pilot visual is **From Performance to Evidence: The Human-Centred Digital Learning Loop**. It demonstrates the workflow without claiming that a visual, an interaction, or a tracked event is by itself evidence of learning or transfer.

## Start here

1. Review `series/series.json` and `design-system/tokens.json`.
2. Invoke `$canva-educational-series-director` with a visual brief.
3. Run `powershell -ExecutionPolicy Bypass -File scripts/validate-series.ps1`.
4. Publish only after the visual has reached the `accessible` state.

## Public links

- Canva pilot: https://www.canva.com/d/CJtD5pPHceXPyt0
- Interactive companion: https://alvarezgzx-lab.github.io/accessible-learning-visual-series/

## Evidence and accessibility policy

Academic claims default to peer-reviewed sources published within the previous three calendar years. Current standards may be older. WCAG 2.2 AA is the minimum web target; UDL Guidelines 3.0 and plain-language principles guide representation and comprehension.

## License

Code is released under the MIT License. Written guidance, visual specifications, and templates are released under CC BY 4.0.
