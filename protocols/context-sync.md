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
  - **Monorepo & Workspace Topology** (if present: package graph, `--filter` commands, import boundaries)
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

### 3. Living Project Tracker Inspection (`docs/STATE.md`)
Check if `./docs/STATE.md` exists in the host project:
- If present, parse:
  - **Active Milestone & Status**: Current phase (e.g. Milestone 2: Core Domain Logic), overall state (`ACTIVE`, `BLOCKED`, `STABILIZING`).
  - **Active Working Set**: Target workspace package (if monorepo), current feature RFC (`docs/specs/...`), target files in flight, and scoped verification commands.
  - **Locked Technical Invariants**: Non-negotiable decisions from previous sessions (e.g. UUIDv7 keys, HttpOnly cookies, tenant RLS, package import rules).
  - **Known Blockers & Risks**: Immediate impediments to resolve or work around.
  - **Next Immediate Actions**: The prioritized next tasks queued for execution.
- If `docs/STATE.md` is missing, rely on git status, active issue specs, and `PROMPTKIT.md`.

### 4. Technology & Runtime Detection
Scan the workspace root and key subdirectories for project manifests:
- **Monorepo Managers & Workspaces**: Turborepo (`turbo.json`), pnpm workspaces (`pnpm-workspace.yaml`), Nx (`nx.json`), Lerna (`lerna.json`), Bun (`bunfig.toml`), or npm/yarn workspaces (`"workspaces"` in root `package.json`).
- **Node.js / TypeScript**: `package.json`, `tsconfig.json`, `pnpm-lock.yaml`, `bun.lockb`
- **Python**: `pyproject.toml`, `requirements.txt`, `Pipfile`, `uv.lock`
- **Go / Rust / Java**: `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`
- **Frontend Frameworks**: Next.js, Vite, Remix, Astro, SvelteKit, React 19, Vue, Nuxt
- **Styling & UI**: Tailwind CSS (v3 vs v4), CSS Modules, Radix UI, Shadcn UI, Styled Components
- **State Management**: TanStack Query / SWR, Zustand, Redux Toolkit, Jotai, Pinia
- **Database / ORM**: Prisma, Drizzle, Kysely, TypeORM, SQLAlchemy, Mongoose, Supabase Postgres
- **Authentication**: Supabase Auth, NextAuth / Auth.js, Clerk, Lucia, Better-Auth, Kinde, Stytch
- **API & Routing**: tRPC, Hono, Next.js Route Handlers, Express, Fastify, FastAPI, GraphQL
- **Testing Suites**: Vitest, Jest, Playwright, Cypress, Pytest, Go testing
- **Deployment & Hosting**: Vercel, Cloudflare Pages/Workers, Fly.io, Railway, AWS, GCP, Docker, Kubernetes
- **CI / CD Pipelines**: GitHub Actions (`.github/workflows`), GitLab CI, CircleCI

### 5. Architecture & Pattern Recognition
Identify existing project structural patterns:
- **Layering**: Feature-sliced (`src/features/*`), Layered (`src/controllers`, `src/services`, `src/repositories`), Clean / Hexagonal (`domain`, `application`, `infrastructure`).
- **Monorepo Topology & Workspace Scoping**:
  - **Catalog Package Graph**: Map apps (`apps/*`) and shared packages (`packages/*`, `libs/*`). Read each package's `package.json` name (e.g. `@repo/web`, `@repo/db`).
  - **Owning Package Correlation**: Correlate files currently in flight with their owning workspace package.
  - **Command Scoping Law**: NEVER execute unbounded root test, typecheck, or build commands when working on a specific package. Always filter commands by workspace package (e.g. `pnpm --filter <pkg> test`, `turbo run test --filter=<pkg>`, `nx test <project>`). Unfiltered root runs exhaust terminal context, slow down the inner loop, and mask localized package isolation bugs.
  - **Enforce Architectural Import Boundaries**: Verify that UI/presentation packages (`packages/ui`) never import database or backend services (`packages/db`), client components never import server secrets, and all cross-package imports consume public package exports rather than reaching into private internals (`../../packages/db/src/...`).
- **API Style**: RESTful (OpenAPI), tRPC, GraphQL, Server Actions, gRPC.
- **Strictness**: TypeScript `strict: true`, ESLint config, Prettier rules, Biome, Ruff.

### 6. Git Status & Recent Evolution
Check active branches and recent changes:
- Run `git status -s` to see uncommitted work.
- Run `git log -n 5 --oneline` to understand recent milestones.
- Identify current pain points or WIP areas.

### 7. Context Synthesis Summary
Generate a 3-4 bullet point internal context summary before executing any workflow:
```markdown
- **Project Profile**: [From PROMPTKIT.md if present, e.g. Acme Dashboard (B2B Logistics)]
- **Visual Identity**: [From DESIGN.md if present, e.g. Deep Forest Green + Ochre Gold Accent, 6px radius, matte]
- **Project State**: [From docs/STATE.md if present, e.g. Milestone 2: In Progress (3/6 tasks done), 0 blockers]
- **Stack**: [e.g., Next.js 15 (App Router) + TypeScript Strict + Tailwind v4 + Drizzle]
- **Auth & Data**: [e.g., Supabase Auth + Row-Level Security + PostgreSQL]
- **API Layer**: [e.g., tRPC v11 + Server Actions]
- **Testing Commands**: [e.g., pnpm test (Unit) + pnpm test:e2e (Playwright)]
- **Active Task / Branch**: [e.g., feature/auth-rate-limiting, 3 files modified]
```

---

## Usage in Workflows
- **Checkpoint (`pk:checkpoint`)**: Synchronizes session accomplishments, locked invariants, and next actions directly back to `docs/STATE.md`.
- **Tasks (`pk:tasks`)**: Reflects milestone decomposition and active task checklists into `docs/STATE.md`.
- **Data (`pk:data`)**: Adapts schema and RLS policies to the detected database engine and ORM.
- **Auth (`pk:auth`)**: Aligns session strategy, cookie rules, and RBAC matrix to the detected auth library.
- **API (`pk:api`)**: Conforms endpoint definitions to existing router styles (tRPC, REST, or Server Actions).
- **Test (`pk:test`)**: Adapts pyramid seam allocation and runner commands to detected test suites and CI constraints.
- **Ship (`pk:ship`)**: Aligns runtime env validation, migration ordering, smoke tests, and rollback triggers with the detected deployment platform and CI/CD setup.
- **Design System (`pk:design`)**: Translates `DESIGN.md` rules directly into tokens, themes, and accessible component variants.
- **Tutor (`pk:tutor`)**: Tailors analogies and code hints to the exact libraries, idioms, and design tokens used in the codebase.
- **Plan (`pk:plan`)**: Ensures proposed architectures and UI wireframes fit cleanly into existing folder conventions and design boundaries.
- **Review (`pk:review`)**: Verifies that new code follows established architectural patterns and enforces visual compliance with `DESIGN.md`.
- **Debug (`pk:debug`)**: Narrows down error reproduction based on runtime versions and environment specifics.
