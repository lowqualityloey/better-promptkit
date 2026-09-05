# Design System Workflow (Modern UI/UX & Component Architecture)

## Fast Shorthand
Trigger anytime with: `pk:design` (or `/pk-design`)

## Mission
Guide the developer in designing, engineering, and auditing production-grade, modern UI/UX architectures. Standardize **Design Tokens**, component hierarchies, accessible headless primitives (Radix/Aria), responsive ergonomics (Tailwind v4 / CSS Grid / Container Queries), motion design, and WCAG 2.2 Level AA compliance.

---

## The Modern UI/UX Engineering Stack

```
┌─────────────────────────────────────────────────────────────┐
│               MODERN UI COMPONENT ARCHITECTURE              │
├─────────────────────────────────────────────────────────────┤
│ 1. Design Tokens Layer                                      │
│    (Color scales, Semantic aliases, Typography, Spacing)    │
│├────────────────────────────────────────────────────────────┤
│ 2. Headless Accessibility & Behavior Layer                  │
│    (Radix UI, React Aria, Floating UI - Focus, ARIA, Keys)  │
│├────────────────────────────────────────────────────────────┤
│ 3. Style & Variant Layer                                    │
│    (Tailwind CSS v4, CSS Variables, Class Variance Authority)│
│├────────────────────────────────────────────────────────────┤
│ 4. Composable Component Layer                               │
│    (Atomic design: Primitives -> Composite Patterns)        │
│├────────────────────────────────────────────────────────────┤
│ 5. UX Ergonomics & Motion Layer                             │
│    (Loading skeletons, Optimistic UI, Framer Motion, a11y)  │
└─────────────────────────────────────────────────────────────┘
```

---

## Preconditions
- Developer is building or refactoring UI components, a design system, or user interaction flows.
- Access to `.promptkit/templates/design-tokens-spec.md`.

---

## Workflow Steps

### Step 1: Design Tokens & Semantic Foundations
1. Define the 3 tiers of design tokens:
   - **Primitive Tokens**: Raw values (e.g., `--blue-500: #3b82f6`, `--space-4: 1rem`).
   - **Semantic Tokens**: Contextual aliases (e.g., `--color-brand-primary`, `--color-surface-elevated`, `--color-danger-subtle`).
   - **Component Tokens**: Specific component bindings (e.g., `--button-primary-bg: var(--color-brand-primary)`).
2. Establish Light/Dark Theme Color Contrast:
   - Verify WCAG 2.2 AA contrast ratios:
     - Normal text: $\ge 4.5:1$
     - Large text / UI controls: $\ge 3.0:1$
3. Define fluid typography and spacing scales using standard rem/px modular scales.

### Step 2: Headless Accessibility & State Modeling
1. Choose or structure headless primitives:
   - Use headless libraries (Radix UI, React Aria, Headless UI, Ark UI) to handle complex keyboard navigation, focus trapping, screen reader announcements, and portal rendering.
2. Verify Keyboard Navigation Requirements:
   - `Tab` / `Shift+Tab`: Natural logical navigation order.
   - `Enter` / `Space`: Activation of buttons, toggles, checkboxes.
   - `Arrow Keys`: Navigation within composite widgets (menus, dropdowns, tabs, comboboxes).
   - `Escape`: Closes open dialogs, tooltips, popovers, and restores focus to triggering element.
3. Verify ARIA Attributes:
   - Ensure proper `role`, `aria-expanded`, `aria-controls`, `aria-describedby`, `aria-live`, and `aria-hidden` bindings.

### Step 3: Component Variant & Props Architecture
1. Design flexible, type-safe component APIs:
   - Leverage `cva` (Class Variance Authority) or `tailwind-variants` for managing multi-variant styling:
     ```typescript
     import { cva, type VariantProps } from 'class-variance-authority';

     export const buttonVariants = cva(
       'inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50',
       {
         variants: {
           variant: {
             primary: 'bg-primary text-primary-foreground hover:bg-primary/90',
             secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
             outline: 'border border-input bg-background hover:bg-accent hover:text-accent-foreground',
             ghost: 'hover:bg-accent hover:text-accent-foreground',
             destructive: 'bg-destructive text-destructive-foreground hover:bg-destructive/90',
           },
           size: {
             sm: 'h-8 px-3 text-xs',
             md: 'h-10 px-4 text-sm',
             lg: 'h-12 px-6 text-base',
             icon: 'h-10 w-10 p-0',
           },
         },
         defaultVariants: {
           variant: 'primary',
           size: 'md',
         },
       }
     );
     ```
2. Enable component polymorphism (`asChild` pattern via Radix Slot).

### Step 4: Responsive & Modern Layout Ergonomics
1. Modern CSS Layout Strategies:
   - Use **CSS Grid / Subgrid** for 2-dimensional layouts and aligned card grids.
   - Use **Container Queries** (`@container`) over viewport queries for truly modular components.
   - Prevent Layout Shifts (CLS): Explicit width/height on media, aspect-ratio utilities (`aspect-video`, `aspect-square`).
2. Micro-Interactions & Transitions:
   - Smooth 150-200ms ease-out transitions for hover, focus, and state changes.
   - Respect `prefers-reduced-motion` media queries for animations.

### Step 5: UX Polish & State Resilience
1. Ensure all async data components support the 4 core UI states:
   - **Loading State**: Content-shaped skeleton loaders (not generic center spinners).
   - **Empty State**: Friendly illustration/message with a primary action button to get started.
   - **Error State**: Actionable recovery message with a "Retry" trigger.
   - **Success / Data State**: Fluid rendering with optimistic updates where appropriate.

---

## Completion Criteria
- Design tokens defined semantically with dark/light theme support.
- Component accessibility (keyboard navigation & screen reader support) fully audited.
- Type-safe, variant-driven component API implemented.
- Skeletons, empty states, and responsive layouts verified.
