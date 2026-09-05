# Context Sync Protocol

## Purpose
Rapidly inspect the host repository to extract technology stack details, dependency constraints, project-specific non-negotiable rules, visual brand identity (`DESIGN.md`), active architectural patterns, and recent git activity. This ensures all Better-PromptKit workflows operate with high situational awareness without requiring the developer to re-explain their setup.

---

## Execution Steps

### 1. Project Profile Inspection (`PROMPTKIT.md`)
Check if `./PROMPTKIT.md` exists in the repository root:
- If present, parse:
  - **Project Name & Domain**
  - **Specific Test & Lint Commands**
  - **Designated Documentation Paths** (default: `docs/adrs/`, `docs/specs/`, `docs/rca/`)
  - **Strict Non-Negotiables & Guardrails** (e.g., forbidden packages, mandatory schemas, architectural layers)
- Prioritize rules in `PROMPTKIT.md` over generic defaults.

### 2. Brand & Visual Identity Inspection (`DESIGN.md`)
Check if `./DESIGN.md` exists in the repository root:
- If present, parse:
  - **Brand Palette & Tokens**: Core neutrals, primary brand color, and deliberate accent.
  - **Anti-Slop Guardrails**: Forbidden gradients (e.g., generic AI blue-to-purple), glow caps, and aesthetic tone.
  - **Typography Rules**: Heading font, body font, font-variant tabular-nums, and text-wrap balance.
  - **Surfaces & Radii**: Target border radii (`rounded-md`), elevation rules, and glassmorphism dose caps.
  - **Mobile Constraints**: Minimum touch target area ($\ge 44 \times 44\text{px}$) and reflow breakpoints.
- **Single Source of Truth**: Treat `DESIGN.md` as the supreme visual authority for all UI generation, styling, and design reviews (`pk:design`, `pk:review`).

### 3. Technology & Runtime Detection
Scan the workspace root and key subdirectories for project manifests:
- **Node.js / TypeScript**: `package.json`, `tsconfig.json`, `pnpm-lock.yaml`, `bun.lockb`
- **Python**: `pyproject.toml`, `requirements.txt`, `Pipfile`, `uv.lock`
- **Go / Rust / Java**: `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`
- **Frontend Frameworks**: Next.js, Vite, Remix, Astro, SvelteKit, React 19, Vue, Nuxt
- **Styling & UI**: Tailwind CSS (v3 vs v4), CSS Modules, Radix UI, Shadcn UI, Styled Components
- **State Management**: TanStack Query / SWR, Zustand, Redux Toolkit, Jotai, Pinia
- **Database / ORM**: Prisma, Drizzle, TypeORM, SQLAlchemy, Mongoose, Supabase
- **Testing Suites**: Vitest, Jest, Playwright, Cypress, Pytest, Go testing

### 4. Architecture & Pattern Recognition
Identify existing project structural patterns:
- **Layering**: Feature-sliced (`src/features/*`), Layered (`src/controllers`, `src/services`, `src/repositories`), Clean / Hexagonal (`domain`, `application`, `infrastructure`), Monorepo (`apps/*`, `packages/*`).
- **API Style**: RESTful (OpenAPI), tRPC, GraphQL, Server Actions, gRPC.
- **Strictness**: TypeScript `strict: true`, ESLint config, Prettier rules, Biome, Ruff.

### 5. Git Status & Recent Evolution
Check active branches and recent changes:
- Run `git status -s` to see uncommitted work.
- Run `git log -n 5 --oneline` to understand recent milestones.
- Identify current pain points or WIP areas.

### 6. Context Synthesis Summary
Generate a 3-4 bullet point internal context summary before executing any workflow:
```markdown
- **Project Profile**: [From PROMPTKIT.md if present, e.g. Acme Dashboard (B2B Logistics)]
- **Visual Identity**: [From DESIGN.md if present, e.g. Deep Forest Green + Ochre Gold Accent, 6px radius, matte]
- **Stack**: [e.g., Next.js 15 (App Router) + TypeScript Strict + Tailwind v4 + Prisma]
- **State/Data Layer**: [e.g., TanStack Query v5 + Server Actions + PostgreSQL]
- **Testing Commands**: [e.g., pnpm test (Unit) + pnpm test:e2e (Playwright)]
- **Active Task / Branch**: [e.g., feature/auth-rate-limiting, 3 files modified]
```

---

## Usage in Workflows
- **Design System (`pk:design`)**: Translates `DESIGN.md` rules directly into tokens, themes, and accessible component variants.
- **Tutor (`pk:tutor`)**: Tailors analogies and code hints to the exact libraries, idioms, and design tokens used in the codebase.
- **Plan (`pk:plan`)**: Ensures proposed architectures and UI wireframes fit cleanly into existing folder conventions and design boundaries.
- **Review (`pk:review`)**: Verifies that new code follows established architectural patterns and enforces visual compliance with `DESIGN.md`.
- **Debug (`pk:debug`)**: Narrows down error reproduction based on runtime versions and environment specifics.
