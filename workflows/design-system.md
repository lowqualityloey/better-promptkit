# Design System Workflow (Modern UI/UX & Component Architecture)

## Fast Shorthand
Trigger anytime with: `pk:design` (or `/pk-design`)

## Mission
Guide the developer in designing, engineering, and auditing production-grade, human-crafted UI/UX architectures. Standardize **Design Tokens**, accessible headless primitives (Radix UI / React Aria), anti-slop aesthetic discipline, responsive mobile reflow, compositor-friendly transitions, and WCAG 2.2 Level AA compliance.

---

## The 5-Layer UI Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│               MODERN UI COMPONENT ARCHITECTURE              │
├─────────────────────────────────────────────────────────────┤
│ 1. Design Tokens & Aesthetic Foundation Layer               │
│    (Brand palette, semantic aliases, fluid type clamp, radii)│
├─────────────────────────────────────────────────────────────┤
│ 2. Headless Accessibility & Behavior Layer                  │
│    (Radix UI / React Aria: focus-visible, ARIA, key traps)  │
├─────────────────────────────────────────────────────────────┤
│ 3. Style & Variant Layer                                    │
│    (Tailwind CSS v4, CVA, compositor-only transform/opacity)│
├─────────────────────────────────────────────────────────────┤
│ 4. Composable Component & React Performance Layer           │
│    (Radix Slot asChild, ternary conditionals, derived state)│
├─────────────────────────────────────────────────────────────┤
│ 5. Mobile Ergonomics & Responsive Reflow Layer              │
│    (≥44px tap targets, min-w-0 flex, dvh, safe-area insets) │
└─────────────────────────────────────────────────────────────┘
```

---

## Preconditions
- Developer is building or refactoring UI components, a design system, or user interaction flows.
- Access to `.promptkit/templates/design-tokens-spec.md`.
- Review project profile in `./PROMPTKIT.md` (if present) for brand identity and styling stack.

---

## Workflow Steps

### Step 1: Design Tokens & Anti-Slop Visual Foundations

1. **Derive the Palette from Brand Identity (`antislop-ui`)**:
   - Ground colors in the product's identity or `DESIGN.md`—**never default to generic AI blue-to-purple gradients, cyan glows, or rainbow borders**.
   - Cap the active palette at 2–3 core colors + 1 intentional accent.
   - **Elevation & Glassmorphism Dose Cap**: Treat glassmorphism (`backdrop-blur`) and heavy drop-shadows as accents, not character traits. Dose cap: at most 1–2 elevated surfaces; everything else sits matte.
   - **Avoid Uniform Pill Syndrome**: Use intentional radii (`rounded-md` or `rounded-lg`). Do not make every button, input, card, and badge pill-shaped (`rounded-full`).

2. **Define the 3 Tiers of Design Tokens**:
   - **Primitive Tokens**: Raw values (e.g., `--slate-900: #0f172a`, `--space-4: 1rem`).
   - **Semantic Tokens**: Contextual aliases (e.g., `--color-brand-primary`, `--color-surface-elevated`, `--color-danger-subtle`).
   - **Component Tokens**: Specific component bindings (e.g., `--button-primary-bg: var(--color-brand-primary)`).

3. **Establish Light/Dark Theme Contrast**:
   - Verify WCAG 2.2 AA contrast ratios:
     - Normal text: $\ge 4.5:1$
     - Large text ($\ge 18\text{pt}$ or $\ge 14\text{pt}$ bold) & UI controls: $\ge 3.0:1$
   - Chart segments and adjacent categorical colors must maintain at least $3:1$ contrast against their neighbors.

4. **Fluid Typography & Micro-Typography Polish (`web-design-guidelines`)**:
   - Use fluid type scaling via `clamp()` (e.g., `clamp(1.5rem, 4vw, 2.5rem)`) so headings scale smoothly with the viewport.
   - Use `text-wrap: balance` or `text-pretty` on headings to prevent single trailing words (widows).
   - Use real ellipsis (`…`) rather than three periods (`...`), especially in loading indicators (`"Saving…"`).
   - Use `font-variant-numeric: tabular-nums` for numeric tables, metrics, timers, and counters to eliminate horizontal jitter.

---

### Step 2: Headless Accessibility & Interaction Parity

1. **Headless Primitives (Radix UI / React Aria / Ark UI)**:
   - Always build composite widgets (modals, dropdowns, comboboxes, tabs, tooltips) on top of battle-tested headless primitives to guarantee correct focus trapping, screen reader announcements, and portal rendering.

2. **Focus State Discipline**:
   - **Never use `outline-none` without an immediate replacement**: Always pair with `:focus-visible:ring-2` (e.g., `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-primary`).
   - Use `:focus-visible` over `:focus` to ensure focus rings only appear during keyboard navigation, not on mouse clicks.
   - Group compound controls using `:focus-within`.

3. **Keyboard Navigation & Hit Parity**:
   - `Tab` / `Shift+Tab`: Natural logical navigation order.
   - `Enter` / `Space`: Activation of buttons, toggles, and checkboxes.
   - `Arrow Keys`: Navigation within composite widgets (menus, dropdowns, tabs, segmented controls).
   - `Escape`: Closes open dialogs, tooltips, and popovers, returning focus to the triggering element.
   - **Hover-to-Tap Parity**: Mobile screens have no hover. Every hover reveal or tooltip must have a tap equivalent and visible `:active` feedback.

4. **ARIA & Semantic HTML Standards**:
   - Use semantic HTML tags first (`<button>`, `<main>`, `<dialog>`, `<table>`, `<nav>`) before reaching for ARIA.
   - Strict element semantics: `<button>` for actions/mutations; `<a>` or `<Link>` for navigation. **Never `<div onClick>`**.
   - **Icon-Only Buttons**: Any button containing only an icon (`<button><TrashIcon /></button>`) **must** include an explicit `aria-label="Delete item"`.
   - **Decorative Icons**: Icons paired with visible text must include `aria-hidden="true"`.
   - **Live Regions**: Dynamic async notifications (toasts, inline form validation) must declare `aria-live="polite"`.

---

### Step 3: Form Ergonomics & Input Hygiene

1. **Never Block Paste**: Never intercept `onPaste` with `preventDefault()`. Users rely on password managers and verification code pasting.
2. **Input Types & Autocomplete**:
   - Specify accurate `type` (`email`, `tel`, `url`, `number`) and `inputmode` (`numeric`, `decimal`).
   - Include standard `autocomplete` attributes (`email`, `username`, `current-password`, `new-password`, `tel`).
   - Set `spellCheck={false}` on emails, codes, and usernames.
3. **Continuous Hit Targets**:
   - Checkboxes and radio buttons must share a single, unbroken hit target with their labels (no dead zones between box and text).
4. **Error Recovery**:
   - Display errors inline beside the offending field with clear remediation instructions.
   - Focus the first invalid field upon form submission failure.

---

### Step 4: Component Variant Architecture & React Runtime Performance

1. **Type-Safe Variants with Class Variance Authority (`cva`)**:
   ```typescript
   import * as React from 'react';
   import { cva, type VariantProps } from 'class-variance-authority';
   import { Slot } from '@radix-ui/react-slot';

   export const buttonVariants = cva(
     'inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 min-h-[44px] px-4 py-2 select-none active:scale-[0.98]',
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
           sm: 'min-h-[36px] h-9 px-3 text-xs',
           md: 'min-h-[44px] h-11 px-4 text-sm',
           lg: 'min-h-[48px] h-12 px-6 text-base',
           icon: 'min-h-[44px] min-w-[44px] h-11 w-11 p-0',
         },
       },
       defaultVariants: {
         variant: 'primary',
         size: 'md',
       },
     }
   );

   export interface ButtonProps
     extends React.ButtonHTMLAttributes<HTMLButtonElement>,
       VariantProps<typeof buttonVariants> {
     asChild?: boolean;
   }

   export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
     ({ className, variant, size, asChild = false, ...props }, ref) => {
       const Comp = asChild ? Slot : 'button';
       return (
         <Comp
           className={buttonVariants({ variant, size, className })}
           ref={ref}
           {...props}
         />
       );
     }
   );
   Button.displayName = 'Button';
   ```

2. **React Rendering Discipline (`vercel-react-best-practices`)**:
   - **Ternary Conditionals**: Always use `condition ? <Component /> : null` instead of `condition && <Component />` to prevent accidental `0` DOM renders.
   - **Derived State During Render**: Calculate filtered lists, selected items, and derived state directly in the render body. Do not duplicate state inside `useEffect`.
   - **No Inline Component Declarations**: Never define helper components inside the render scope of another component (causes unmount/remount loops and lost focus).
   - **Non-Urgent Transitions**: Use `useTransition` / `startTransition` for tab switches and filter changes so text input and button clicks remain immediately responsive.

---

### Step 5: Mobile Ergonomics & Responsive Reflow (`antislop-layoutmobile`)

1. **Reflow over Shrinking**:
   - **Core Principle**: *"Mobile layout is a different layout, not desktop squeezed into a phone."*
   - Multi-column grids must collapse and stack into single-column reflowing flows at narrow viewports rather than squeezing content into unreadable slivers.
   - Breakpoints must be placed where content breaks, not based on arbitrary device model dimensions.

2. **Touch Targets ($\ge 44 \times 44\text{px}$)**:
   - Every interactive target (buttons, icons, toggles, links) must maintain a minimum touch hit area of **$44 \times 44\text{px}$**, even if the visual icon inside is smaller.
   - Maintain at least $8\text{px}$ spacing between adjacent touch targets so thumbs never mis-tap.

3. **Prevent Horizontal Scroll Leaks**:
   - Flex and Grid children must include `min-w-0` to allow text truncation (`truncate`, `line-clamp-*`) without forcing parent container blowout.
   - All images, canvas, and video elements must include `max-w-full h-auto`.
   - Tables on mobile must either scroll within an isolated container (`overflow-x-auto`) or reflow into card lists.

4. **Dynamic Viewport Height & Safe Areas**:
   - Use `dvh` (e.g. `min-h-dvh`, `h-dvh`) instead of `100vh` to prevent jumping when mobile browser URL bars appear or hide.
   - Fixed bottom navigation bars and sticky headers must reserve space for content and respect safe-area insets:
     ```css
     padding-bottom: max(1rem, env(safe-area-inset-bottom));
     ```

---

### Step 6: Motion & Compositor-Friendly Transitions

1. **Animate `transform` and `opacity` Only**:
   - Avoid animating layout properties (`width`, `height`, `margin`, `padding`, `top`, `left`) which trigger browser layout recalculations and jank.
   - **Never use `transition: all`**: Explicitly declare transitioned properties (e.g., `transition-colors duration-150 ease-out`, `transition-transform duration-200`).

2. **Respect `prefers-reduced-motion`**:
   - Always provide a reduced-motion fallback:
     ```css
     @media (prefers-reduced-motion: reduce) {
       *, *::before, *::after {
         animation-duration: 0.01ms !important;
         animation-iteration-count: 1 !important;
         transition-duration: 0.01ms !important;
       }
     }
     ```
   - Avoid endless, un-prompted pulsing or floating loops. Motion must guide user focus, not act as distracting wallpaper.

---

### Step 7: Content Resilience & Empty States

Ensure all async components support the 4 fundamental UI states with meaningful messaging:
1. **Loading State**: Content-shaped skeleton loaders matching the exact dimensions of final content (not generic spinners).
2. **Empty State**: Explain *why* the view is empty and provide the single primary action button to populate it (e.g., `"No books in your library yet. Browse the catalog to add your first book."`).
3. **Error State**: Actionable recovery message with a `"Retry"` trigger.
4. **Success / Data State**: Fluid rendering with optimistic UI updates where appropriate.

---

## 📋 UI Delivery Gate Checklist

Before marking any UI task complete, verify all criteria pass:

- [ ] **Aesthetic Craft**: Palette is derived from brand identity; no generic blue/purple AI gradients, no decorative emoji, and glass/glow is limited to 1–2 elements.
- [ ] **Contrast Compliance**: Normal text passes $\ge 4.5:1$ and large text/UI controls pass $\ge 3.0:1$ in both light and dark themes.
- [ ] **Focus Replacement**: No `outline-none` without an immediate `:focus-visible:ring-2` replacement.
- [ ] **Accessible Icon Buttons**: Every icon-only button includes an `aria-label`; decorative icons have `aria-hidden="true"`.
- [ ] **Semantic Elements**: Buttons use `<button>`, links use `<a>`/`<Link>`; zero `<div onClick>`.
- [ ] **Form Hygiene**: Paste is never blocked; fields have `autocomplete`, shared hit targets, and inline error recovery.
- [ ] **Touch Targets**: All interactive targets are $\ge 44 \times 44\text{px}$ with adequate finger spacing.
- [ ] **Mobile Reflow**: Zero horizontal scroll leaks (`min-w-0` on flex/grid children), viewport uses `dvh`, and bottom nav respects safe-area insets.
- [ ] **Compositor Motion**: Only `transform` and `opacity` animate; no `transition: all`; `prefers-reduced-motion` honored.
- [ ] **React Performance**: Conditionals use ternary (`? : null`); derived state is computed during render; no nested inline components.
