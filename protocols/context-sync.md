# Context Sync Protocol

## Purpose
Rapidly inspect the host repository to extract technology stack details, dependency constraints, project-specific non-negotiable rules, active architectural patterns, and recent git activity. This ensures all Better-PromptKit workflows operate with high situational awareness without requiring the developer to re-explain their setup.

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

### 2. Technology & Runtime Detection
Scan the workspace root and key subdirectories for project manifests:
- **Node.js / TypeScript**: `package.json`, `tsconfig.json`, `pnpm-lock.yaml`, `bun.lockb`
- **Python**: `pyproject.toml`, `requirements.txt`, `Pipfile`, `uv.lock`
- **Go / Rust / Java**: `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`
- **Frontend Frameworks**: Next.js, Vite, Remix, Astro, SvelteKit, React 19, Vue, Nuxt
- **Styling & UI**: Tailwind CSS (v3 vs v4), CSS Modules, Radix UI, Shadcn UI, Styled Components
- **State Management**: TanStack Query / SWR, Zustand, Redux Toolkit, Jotai, Pinia
- **Database / ORM**: Prisma, Drizzle, TypeORM, SQLAlchemy, Mongoose, Supabase
- **Testing Suites**: Vitest, Jest, Playwright, Cypress, Pytest, Go testing

### 3. Architecture & Pattern Recognition
Identify existing project structural patterns:
- **Layering**: Feature-sliced (`src/features/*`), Layered (`src/controllers`, `src/services`, `src/repositories`), Clean / Hexagonal (`domain`, `application`, `infrastructure`), Monorepo (`apps/*`, `packages/*`).
- **API Style**: RESTful (OpenAPI), tRPC, GraphQL, Server Actions, gRPC.
- **Strictness**: TypeScript `strict: true`, ESLint config, Prettier rules, Biome, Ruff.

### 4. Git Status & Recent Evolution
Check active branches and recent changes:
- Run `git status -s` to see uncommitted work.
- Run `git log -n 5 --oneline` to understand recent milestones.
- Identify current pain points or WIP areas.

### 5. Context Synthesis Summary
Generate a 3-4 bullet point internal context summary before executing any workflow:
```markdown
- **Project Profile**: [From PROMPTKIT.md if present, e.g. Acme Dashboard (B2B Logistics)]
- **Stack**: [e.g., Next.js 15 (App Router) + TypeScript Strict + Tailwind v4 + Prisma]
- **State/Data Layer**: [e.g., TanStack Query v5 + Server Actions + PostgreSQL]
- **Testing Commands**: [e.g., pnpm test (Unit) + pnpm test:e2e (Playwright)]
- **Active Task / Branch**: [e.g., feature/auth-rate-limiting, 3 files modified]
```

---

## Usage in Workflows
- **Tutor (`pk:tutor`)**: Tailors analogies and code hints to the exact libraries and idioms used in the codebase.
- **Plan (`pk:plan`)**: Ensures proposed architectures fit cleanly into existing folder conventions and dependency trees.
- **Review (`pk:review`)**: Verifies that new code follows established architectural patterns and conventions.
- **Debug (`pk:debug`)**: Narrows down error reproduction based on runtime versions and environment specifics.
