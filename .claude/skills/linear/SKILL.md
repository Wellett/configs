---
name: linear
description: Use this skill when the user wants to work with Linear — creating, drafting, or updating issues, managing projects, milestones. Invoke it as soon as a Linear task begins, including while drafting issue content before anything is saved — the skill's field conventions are needed to draft correctly, not just to submit. Trigger on: "create a Linear issue", "draft a Linear ticket/issue", "write a Linear ticket", "plan a Linear issue", "update this issue", "create a linear milestone", "linear project", "list linear issues", "Linear ticket".
version: 1.1.0
---

# Linear Skill

## Workspace IDs

| Resource | Name | ID |
|---|---|---|
| Team | PdM - Data acquisition | `eb5ecbb2-0f5b-4961-b298-3f9dda874504` |
| Project | Firmware Management | `b88f69e0-16c2-4b9c-ae8a-628f3e883eae` |

## Team Members

| Name | ID |
|---|---|
| William Ellett | `0b43b5b2-97f7-42f9-86df-9a0328cab97e` |
| Mariano Ruau Asprela | `d8e866ff-6b2d-4eac-9397-f396b0c2b77e` |
| Wouter De Leeuw | `33329d18-944c-4fae-b57a-4c3081ce2495` |
| Floris Jonkman | `f1697020-eebe-4738-91e5-30e57237fd81` |
| Evelijn Verboom | `e9e6b81d-3a72-4dec-90a4-78d5ca90ac44` |

## Issue Description Template

When creating or updating an issue description, use the following structure where applicable. Omit sections that are not relevant.

```markdown
Brief one or two sentence summary of what this ticket is about and why it matters.

## Context
Why does this work need to happen? What is the background, motivation, and any existing systems, infrastructure, or constraints that are relevant?

## Requirements
What must be true when this is done? Use a checklist or bullet list.

## Proposed Solution
How should this be implemented? Keep it concise — link to designs or docs if needed.

## Out of Scope
What is explicitly NOT included in this ticket to avoid scope creep?

## Open Questions
Unresolved decisions or unknowns that need an answer before or during implementation.

## Risks
What could go wrong? What are the potential negative consequences or unknowns?
```

## Rules

- When creating and modifying issues, never create or modify the issue without confirmation. Show the user the issue and ask for confirmation before saving.
- **Always use IDs for assignments** — resolving by name is unreliable.
- `priority`: 0 = none, 1 = urgent, 2 = high, 3 = medium, 4 = low.
- To move an issue to a new status, call `list_issue_statuses` first to get the `stateId`.
- When the user says "todo", treat it as "Sprint backlog" status (`29804a31-08ae-4466-b750-31b3c4b92398`).
- Save new IDs (labels, milestones, etc.) to memory for future use.
- Confirm with the user before any delete operation.
- If no priority is specified when creating an issue, default to "medium" (3), check this with the user.
