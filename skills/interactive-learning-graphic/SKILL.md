---
name: interactive-learning-graphic
description: Build or update the accessible HTML/SVG companion for an educational visual, including progressive disclosure, deep links, evidence references, text equivalents, and skill downloads. Use when a visual needs optional depth or source-level exploration. Do not use when a concise static visual and its alt text fully communicate the content.
---

# Interactive Learning Graphic

Use semantic HTML as the source of truth and SVG only as an enhanced representation.

## Requirements

1. Load content from the approved visual manifest or keep a single synchronized data copy.
2. Provide Overview, Frameworks, Technology and Evidence views when relevant.
3. Use native links, buttons and disclosure elements. Everything must work by keyboard and without hover.
4. Maintain visible focus, logical headings, landmarks and a skip link.
5. Support hash deep links such as `#evidence`.
6. Keep all essential stage content and references available when JavaScript fails.
7. Provide an ordered-list or table equivalent and the manifest long description.
8. Link evidence at the claim and include a full reference index.
9. Link each public skill for reading and direct Markdown download.
10. Reflow at 320 CSS px and 200% zoom; honor reduced motion.

Do not add drag, zoom, authentication, analytics, a backend or personal-data collection in version 1.
