# Canva component library

Use this file as the construction contract for the Brand Kit and master templates. The JSON tokens remain the source of truth.

## Shared components

### Series masthead

- Eyebrow: series name, sentence case, `teal`.
- Title: one strong statement, `ink`, maximum two lines.
- Technical subtitle: short English label, `rust`, maximum one line.
- Optional issue marker: `P01`, never the sole identifier.

### Evidence card

- Visible claim in plain language.
- Framework label and short explanation.
- Source marker such as `[S1]`, linked in the digital PDF when Canva supports it.
- Never place a DOI in the main reading path; put full references in the final panel or companion.

### Step card

- Number, action-oriented heading, one short question and one observable output.
- A meaningful icon with adjacent label.
- Relationship arrow plus a numbered reading order; color alone is insufficient.

### Companion invitation

- Visible label: `Explore evidence and sources`.
- Short public URL and QR code.
- Text must remain usable if the QR code cannot be scanned.

### Evidence boundary

- Label one of: `Supported`, `Interpretation`, `Design decision`, `Needs validation`.
- Include a short reason. Never style an inference as an established result.

## Five master layout families

1. **Modular infographic** — 4–6 independent cards with one synthesis statement.
2. **Flow diagram** — 4–7 connected steps, explicit arrows and a textual sequence.
3. **Layered systems map** — concentric or stacked layers with a legend and equivalent list.
4. **Comparison matrix** — one stable comparison axis, no more than five columns on a single sheet.
5. **Progressive-disclosure carousel** — one idea per slide, persistent orientation and a final reference slide.

## Canva document setup

- Primary social size: 1080 × 1350 px.
- Carousel size: 1080 × 1350 px per slide.
- Maintain a 54 px safe margin.
- Body text target: at least 26 px in social graphics; never shrink below the static minimum to solve density.
- Preserve a logical heading hierarchy and reading order.
- Export PNG for social use and PDF Digital for accessible distribution.
- Run Canva's accessibility checker, then verify the PDF outside Canva.

## Density decision

If the copy cannot fit at the target size with comfortable line spacing:

1. remove duplication;
2. move nuance and sources to the companion;
3. change to a carousel;
4. never reduce body text below the minimum.
