# ADR 0001: Content-First Rendering

- **Status**: Accepted
- **Date**: 2026-09-10

## Decision

Render primary content and navigation statically with Astro, adding client-side JavaScript only for progressive enhancement.

## Rationale

The site prioritizes documentation access, accessibility, SEO, and fast first render over application-style interactivity.

## Consequence

Interactive features must have a useful non-JavaScript baseline and remain within the script budget.
