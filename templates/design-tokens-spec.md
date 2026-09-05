# Modern Design System & Token Specification

- **System Name**: [e.g., Core UI / Nova Design System]
- **Target CSS Framework**: [Tailwind CSS v4 / CSS Modules / StyleX]
- **Accessibility Target**: WCAG 2.2 Level AA Compliance

---

## 1. Color System & Semantic Tokens

### Primitive Color Scale
```css
:root {
  /* Slate Neutral */
  --color-slate-50:  #f8fafc;
  --color-slate-100: #f1f5f9;
  --color-slate-200: #e2e8f0;
  --color-slate-300: #cbd5e1;
  --color-slate-400: #94a3b8;
  --color-slate-500: #64748b;
  --color-slate-600: #475569;
  --color-slate-700: #334155;
  --color-slate-800: #1e293b;
  --color-slate-900: #0f172a;
  --color-slate-950: #020617;

  /* Indigo Brand */
  --color-indigo-500: #6366f1;
  --color-indigo-600: #4f46e5;
  --color-indigo-700: #4338ca;

  /* Emerald Success */
  --color-emerald-500: #10b981;
  --color-emerald-600: #059669;

  /* Rose Destructive / Danger */
  --color-rose-500: #f43f5e;
  --color-rose-600: #e11d48;
}
```

### Semantic Token Aliases (Light & Dark Theme)
```css
/* Light Theme (Default) */
:root {
  --background: var(--color-slate-50);
  --foreground: var(--color-slate-900);
  
  --surface-card: #ffffff;
  --surface-card-foreground: var(--color-slate-900);
  --surface-popover: #ffffff;
  
  --primary: var(--color-indigo-600);
  --primary-foreground: #ffffff;
  
  --secondary: var(--color-slate-100);
  --secondary-foreground: var(--color-slate-900);
  
  --muted: var(--color-slate-100);
  --muted-foreground: var(--color-slate-500);
  
  --border: var(--color-slate-200);
  --input: var(--color-slate-200);
  --ring: var(--color-indigo-600);
  
  --destructive: var(--color-rose-600);
  --destructive-foreground: #ffffff;
}

/* Dark Theme */
.dark {
  --background: var(--color-slate-950);
  --foreground: var(--color-slate-100);
  
  --surface-card: var(--color-slate-900);
  --surface-card-foreground: var(--color-slate-100);
  --surface-popover: var(--color-slate-900);
  
  --primary: var(--color-indigo-500);
  --primary-foreground: #ffffff;
  
  --secondary: var(--color-slate-800);
  --secondary-foreground: var(--color-slate-100);
  
  --muted: var(--color-slate-800);
  --muted-foreground: var(--color-slate-400);
  
  --border: var(--color-slate-800);
  --input: var(--color-slate-800);
  --ring: var(--color-indigo-500);
  
  --destructive: var(--color-rose-500);
  --destructive-foreground: #ffffff;
}
```

---

## 2. Typography Hierarchy & Fluid Scales

```css
:root {
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;

  /* Font Sizes */
  --text-xs:   0.75rem;   /* 12px - Line height: 1rem */
  --text-sm:   0.875rem;  /* 14px - Line height: 1.25rem */
  --text-base: 1rem;      /* 16px - Line height: 1.5rem */
  --text-lg:   1.125rem;  /* 18px - Line height: 1.75rem */
  --text-xl:   1.25rem;   /* 20px - Line height: 1.75rem */
  --text-2xl:  1.5rem;    /* 24px - Line height: 2rem */
  --text-3xl:  1.875rem;  /* 30px - Line height: 2.25rem */
  --text-4xl:  2.25rem;   /* 36px - Line height: 2.5rem */
}
```

---

## 3. Spacing & Elevation (Elevation & Shadows)

```css
:root {
  /* Spacing Scale */
  --space-1: 0.25rem;  /* 4px */
  --space-2: 0.5rem;   /* 8px */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-12: 3rem;    /* 48px */

  /* Border Radii */
  --radius-sm: 0.25rem;
  --radius-md: 0.375rem;
  --radius-lg: 0.5rem;
  --radius-full: 9999px;

  /* Elevation Shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
}
```

---

## 4. Component Implementation Pattern (Tailwind + Radix)

```tsx
import * as React from 'react';
import * as DialogPrimitive from '@radix-ui/react-dialog';
import { cva, type VariantProps } from 'class-variance-authority';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// Accessible Dialog Overlay Pattern
export const DialogOverlay = React.forwardRef<
  React.ElementRef<typeof DialogPrimitive.Overlay>,
  React.ComponentPropsWithoutRef<typeof DialogPrimitive.Overlay>
>(({ className, ...props }, ref) => (
  <DialogPrimitive.Overlay
    ref={ref}
    className={cn(
      'fixed inset-0 z-50 bg-black/60 backdrop-blur-sm data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0',
      className
    )}
    {...props}
  />
));
DialogOverlay.displayName = DialogPrimitive.Overlay.displayName;
```
