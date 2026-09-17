# Accessibility rules

## Required baseline

- WCAG 2.2 AA for the companion.
- UDL Guidelines 3.0 for multiple representations, explicit relationships, agency and transfer.
- ISO 24495-1:2023 principles for plain language.
- Human-centred design cycle aligned with ISO 9241-210:2019, confirmed current in 2025.

## Static Canva visual

- Use a logical heading hierarchy and Canva reading order.
- Provide concise alt text plus a separate long description for complex visuals.
- Pair every icon, state and relationship with text; do not rely on color, position or shape alone.
- Preserve 4.5:1 contrast for normal text and 3:1 for large text and essential graphical objects.
- Treat low-contrast brand colors as decorative only.
- Keep body copy at or above the token minimum.
- Add a visible public URL alongside any QR code.
- Verify exported tagged PDF with a screen reader and an independent PDF accessibility checker.

## Interactive companion

- Semantic HTML is the source of truth; SVG is an enhanced representation.
- All interactive elements are native buttons or links and work by keyboard.
- Focus is visible, persistent and not obscured.
- No essential information appears only on hover.
- At 320 CSS px and 200% zoom, content reflows without horizontal scrolling except a labeled data table when necessary.
- Respect `prefers-reduced-motion` and do not auto-play motion.
- Provide skip links, landmarks, headings, descriptive link text and a text/table equivalent.
- Use hashes for deep links and update expanded state without stealing focus.
- The essential content and references remain available if JavaScript fails.

## Cognitive accessibility

- Use stable labels and consistent placement across the series.
- Present one primary message per visual.
- Make reading order and cause/effect relationships explicit.
- Explain technical labels in Spanish on first use.
- Distinguish activity, interaction, event, evidence and interpretation.
- State limitations beside the relevant claim, not only in a disclaimer.

## Complex-image description pattern

1. State the visual's purpose and main takeaway.
2. Describe structure and reading order.
3. Describe each meaningful block and relationship.
4. Provide an equivalent ordered list or table.
5. Link each evidence marker to its source.
