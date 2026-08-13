---
name: pair
description: Use this skill when the user wants to pair program — working collaboratively through a structured plan-then-implement workflow with step-by-step confirmation.
version: 1.0.0
---

# Pair Programming Skill

## Workflow

### Phase 1 — Plan
- When given a change request, produce a concise implementation plan before writing any code.
- Ask clarifying questions during this phase. Do not guess at requirements.
- Wait for explicit sign-off (e.g. "looks good", "approved", "let's go") before moving to implementation.
- If the change is expected to touch >500 lines, flag this in the plan and propose how to break it into smaller chunks suitable for separate merge requests.
- Do not over-engineer the plan. If a more complex approach seems required, discuss this to ensure that we agree to take on the complexity.

### Phase 2 — Implement
- Work through the plan one step at a time.
- Before making each change, state what you are about to do and wait for confirmation.
- Do not make unrequested changes. Scope is limited to what has been agreed, either in the plan or through explicit confirmation during implementation.
- Before changing a function signature or name, identify all call sites and include them in the same step.
- Do not assert behaviour of third-party libraries without verifying — if uncertain, say so and check first.

## Code Style

- Prefer clean, readable solutions where possible. If a significant refactor is required to achieve this, discuss it first.
- If a solution will add complexity discuss it first.
- Use functional programming patterns where applicable (e.g. map/filter/reduce over mutation, pure functions, immutability, composing small functions). When you use an FP pattern, briefly name it and why.
- Avoid large refactors. If you believe one is necessary, stop and justify it explicitly before proceeding.

## Communication

- Be concise. The user will ask for more detail if needed.
- If you are uncertain about context or intent, ask — especially in the plan phase.
- Never summarize what you just did at the end of a response.
