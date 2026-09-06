# Brand & Design Identity Specification (`DESIGN.md`)

> **Instructions for AI**: Read this file during every session. This document is the single source of truth for the project's visual identity, styling tokens, typography, surfaces, and anti-slop design guardrails. All UI code must conform to these rules.

---

## 1. Brand Essence & Visual Character
- **Product Name**: [e.g., Shelf / Acme Analytics]
- **Brand Personality**: [e.g., Clean, industrial, high-signal, utilitarian, editorial]
- **Theme Default**: [Light theme default | Dark theme default | System auto with toggle]
- **Aesthetic Tone**: [e.g., Grounded matte surfaces, generous whitespace, high contrast, zero unnecessary decoration]

---

## 2. Color Palette & Anti-Slop Guardrails
> 🚫 **Anti-Slop Rule**: Never use generic AI blue-to-purple / cyan gradients, rainbow glow backdrops, or neon pastel palettes. All colors must derive strictly from the tokens below.

### Core Colors
- **Neutral Base**: [e.g., Slate / Zinc / Neutral]
  - Background (Light): `#f8fafc` | Background (Dark): `#020617`
  - Foreground (Light): `#0f172a` | Foreground (Dark): `#f8fafc`
  - Border: `#e2e8f0` (Light) | `#1e293b` (Dark)
- **Brand Primary**: [e.g., Deep Forest Green `#1b4332` or Indigo `#4f46e5`]
- **Brand Secondary**: [e.g., Sage `#74c69d` or Slate `#64748b`]
- **Deliberate Accent**: [e.g., Ochre Gold `#d4a373` or Amber `#f59e0b`]. **Used at key focal moments only, never scattered everywhere.**
- **Semantic Feedback**:
  - Success: `#10b981` (Emerald)
  - Destructive / Error: `#e11d48` (Rose)
  - Warning: `#f59e0b` (Amber)

---

## 3. Typography Hierarchy
- **Heading Font**: [e.g., 'Cabinet Grotesk', 'Plus Jakarta Sans', or system sans]
  - Headings rule: Use `text-wrap: balance` or `text-pretty` to prevent orphan words (widows).
- **Body Font**: [e.g., 'Inter', 'Geist', or system-ui]
  - Body rule: High readability with minimum 1.5 line height (`leading-relaxed`).
- **Code & Numeric Font**: [e.g., 'JetBrains Mono', 'Fira Code']
  - Numbers rule: Mandatory `font-variant-numeric: tabular-nums` for timers, financial counters, and data tables.
- **Punctuation Standard**: Always use real ellipsis (`…`), curly quotes (`“”`), and non-breaking spaces for units (`10&nbsp;MB`, `⌘&nbsp;K`).

---

## 4. Surfaces, Radius & Elevation
- **Border Radii (Intentional Hierarchy)**:
  - Small elements (badges, tags): `rounded-sm` (4px)
  - Standard controls (buttons, inputs): `rounded-md` (6px)
  - Containers (cards, dialogs): `rounded-lg` (8px)
  - 🚫 **Anti-Pill Rule**: Reserve `rounded-full` strictly for avatar circles and indicator dots. Do not create uniform pill-shaped cards or inputs.
- **Glassmorphism & Elevation Dose Cap**:
  - Dose cap: At most 1–2 frosted (`backdrop-blur`) or elevated surfaces across an entire view.
  - Cards and list rows sit flat and matte with a subtle 1px border.

---

## 5. Mobile Ergonomics & Responsive Reflow
- **Touch Target Minimum**: Every button, input, toggle, and nav link must have a hit area of at least **$44 \times 44\text{px}$** with finger-width spacing.
- **Reflow over Shrinking**: Multi-column grids must collapse and stack into single-column flows on mobile viewports.
- **Zero Horizontal Scroll**: All flex/grid children must declare `min-w-0` to allow clean text truncation (`truncate`, `line-clamp-*`).
- **Viewport Units**: Use `dvh` (dynamic viewport height) for full-screen dialogs and drawers; never use `100vh`.
- **Safe-Area Insets**: Fixed bottom bars and sticky navigation must include `env(safe-area-inset-bottom)`.

---

## 6. Motion & Interaction Rules
- **Compositor Transitions Only**: Animate `transform` and `opacity` only. Never use `transition: all`.
- **Reduced Motion**: Always provide reduced-motion fallbacks (`@media (prefers-reduced-motion: reduce)`).
- **No Endless Loops**: No unprompted pulsing, floating, or bouncing animations.
- **Hover-to-Tap Parity**: Every hover effect must have an active touch state (`:active`) and tap equivalent.
