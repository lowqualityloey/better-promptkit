# Session Checkpoint & Handover Workflow

## Fast Shorthand
Trigger anytime with: `pk:checkpoint` (or `/pk-checkpoint`, `pk:handoff`)

## Mission
Eliminate AI context window degradation, token lag, and instruction drift during extended pairing sessions. Compress the active working state into an architectural snapshot and generate a plug-and-play **Handover Prompt** to resume work in a fresh chat window with zero lost context.

---

## Preconditions
- The active chat session has exceeded 20-30 turns, or the assistant is exhibiting memory drift or lag.
- The developer is switching tasks, ending work for the day, or handing off to another engineer or agent.

---

## 4-Phase Checkpoint Protocol

```text
┌─────────────────────────────────────────────────────────────┐
│                  PK:CHECKPOINT LIFECYCLE                    │
├──────────────┬──────────────┬──────────────┬────────────────┤
│ Phase 1:     │ Phase 2:     │ Phase 3:     │ Phase 4:       │
│ Workspace    │ Invariant &  │ Pre-Handover │ Clean Handover │
│ Delta Audit  │ State Synthe │ Hygiene Scan │ Prompt Gen     │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

---

### Phase 1: Workspace Delta Audit

Before summarizing, inspect the physical state of the repository:

1. **Branch & Recent Commit**:
   ```bash
   git branch --show-current
   git log -n 1 --oneline
   ```
2. **Uncommitted Modifications**:
   ```bash
   git status -s
   git diff --stat
   ```
3. **Active Test Suite Status**:
   Verify whether tests are currently passing, failing (expected red loop in `pk:debug`), or unverified.

---

### Phase 2: Invariant & State Synthesis

Extract and structure the 5 vital signals of the session:

1. **Core Objective**: What was the primary business or engineering problem being solved?
2. **Completed Milestones**: What was implemented and verified during this session? (Specific files created, endpoints added, schemas migrated).
3. **Locked Architectural Invariants**: What non-negotiable decisions were agreed upon that the next session must not undo? (e.g., "Using UUIDv7 keys", "HttpOnly cookie sessions instead of localStorage", "Zod boundary schemas").
4. **Active Blockers & Open Questions**: What is currently unresolved, failing, or pending user input?
5. **Immediate Next Step**: Exactly what should the very next prompt or turn accomplish?

---

### Phase 3: Pre-Handover Hygiene Scan

Ensure the workspace is in a clean state before switching sessions:
- Verify no secrets (`.env`, tokens) were left untracked in working files.
- Verify whether temporary debug logging probes (`[DEBUG-xxxx]`) need cleanup or are intentionally active for the next turn.
- If there are uncommitted changes that represent a stable milestone, suggest running `pk:commit` before starting the new session.

---

### Phase 4: Clean Handover Prompt Generation

Generate a self-contained, copy-pasteable prompt block formatted for a brand-new chat session:

````markdown
### Handover Prompt for Fresh Chat Session

Copy and paste the block below into a new chat window to resume work with zero lost context:

```markdown
# Session Resume: [Feature / Task Name]

## 1. Context & Environment
- **Branch**: `[branch-name]` at commit `[commit-hash]`
- **Active Task**: [1-sentence summary of the active task]
- **Current Status**: [e.g., Schema migrated, backend endpoints complete, frontend pending]

## 2. Key Files to Inspect
- `[path/to/file1.ts]`: [Role of this file]
- `[path/to/file2.ts]`: [Role of this file]
- `docs/[specs|data|auth]/...md`: [Active design spec or matrix]

## 3. Locked Technical Invariants (Do Not Undo)
- [Invariant 1, e.g., All database tables use UUIDv7 primary keys]
- [Invariant 2, e.g., Auth sessions require HttpOnly, SameSite=Lax cookies]
- [Invariant 3, e.g., Presentation components must not contain business logic]

## 4. Current State & Immediate Next Step
- **What is done**: [Brief list of completed work]
- **Next immediate action**: [Exact next task to execute]

Please inspect the files listed above and confirm you are ready to proceed with the next step.
```
````

---

## Example Checkpoint Output

### Example: Handing off mid-way through an auth migration

````markdown
[Better-PromptKit: Session Checkpoint Generated]

### Session Summary
* **Objective**: Add email verification invariant to team invite flow.
* **Completed**:
  * Added `email_verified_at` timestamp to `users` table via migration `20260906_add_email_verified_at.sql`.
  * Updated `auth-matrix-template.md` in `docs/auth/email-verification-matrix.md`.
  * Unit tests passing in `tests/auth/verify-email.test.ts`.
* **Pending**: Adding verification barrier in the `inviteUser` server action.

### Ready-to-Paste Handover Prompt for New Chat:

```markdown
# Session Resume: Email Verification Invariant

## 1. Context & Environment
- **Branch**: `feature/email-verification` at commit `9312b1a`
- **Active Task**: Implement verification gate on team invite server action
- **Current Status**: Database migration and auth spec complete; server action update pending

## 2. Key Files to Inspect
- `src/server/actions/invite.ts`: Target server action to protect
- `docs/auth/email-verification-matrix.md`: Auth capability matrix
- `tests/auth/verify-email.test.ts`: Verified test cases

## 3. Locked Technical Invariants
- Unverified users must receive 403 Forbidden with `ERR_EMAIL_UNVERIFIED`
- All verification checks happen on the server session, never trusted from client props

## 4. Next Immediate Action
Update `inviteUser` in `src/server/actions/invite.ts` to enforce the `email_verified_at` check and add an integration test for the rejection path.
```
````
