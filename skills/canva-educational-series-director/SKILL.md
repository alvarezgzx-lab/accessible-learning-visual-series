---
name: canva-educational-series-director
description: Coordinate an evidence-informed educational visual series across Canva, manifests, accessible web companions, and audits. Use when creating or materially revising a Canva learning infographic, flow, map, matrix, carousel, or series; when a brief needs research, layout selection, publication state, and synchronized outputs. Do not use for a typo-only edit or an unrelated bitmap illustration.
---

# Canva Educational Series Director

Coordinate the series without making the user manually invoke every specialist.

## Workflow

1. Read `system-prompt.json`, `series/series.json`, `design-system/tokens.json`, and the relevant visual manifest.
2. Invoke `reflexion-estructurada` for a new series, a material thesis/audience change, or conflicting evidence. Do not repeat the full reflection for mechanical edits within an approved system.
3. Lock the brief: audience, purpose, one main message, desired action, format constraints and publication context.
4. Route work in this order:
   - `$visual-evidence-research`
   - `$canva-accessible-visual`
   - `$interactive-learning-graphic` when the manifest requires it
   - `$visual-accessibility-audit`
5. Update the manifest and `series.json` only after the corresponding output exists.
6. Stop publication if evidence or accessibility gates fail. Otherwise proceed autonomously within locked decisions.

## Material-change test

Request approval only when a change affects the thesis, audience, brand identity, evidence standard, accessibility target, public/private boundary or total production scope.

## State gates

- `draft`: brief and initial manifest exist.
- `reviewed`: claims and sources have passed evidence review.
- `accessible`: static and web outputs have passed the audit.
- `published`: public Canva and companion links have been checked.

Never equate interactivity, event capture or completion with learning, transfer or business impact.
