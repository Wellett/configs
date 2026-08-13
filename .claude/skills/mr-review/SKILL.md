---
name: mr-review
description: Use this skill when the user wants to review a GitLab merge request collaboratively. Trigger on "review this MR", "look at this merge request with me", or when given a GitLab MR URL or "repo #number".
version: 0.1.0
---

# MR Review Skill

Collaborative GitLab merge request review using the `glab` CLI. Repos are cloned under `~/repositories/<group>/<name>`, hosted at `gitlab.com/Sensorfact/...`.

## State model

**A drafted comment IS a GitLab draft note on the server.** There is no local file and
nothing held only in conversation. Draft notes are private to you until published, so they
survive a context reset and are always recoverable.

- **Propose one at a time.** Raise a single concern, show the proposed comment (for inline:
  `file:line — "text"`), and wait. Never bundle multiple comments into one approval prompt.
- **Approval gates creation.** Do not create a draft note until the user approves that
  specific comment. Approval is per-comment.
- **On approval, create immediately.** Once approved, create the draft note right then — never
  hold an approved comment in conversation to create later (that reintroduces the context-loss
  risk drafts exist to avoid). Confirm it was created, then move to the next concern.
- **`GET draft_notes` is the source of truth.** Before summarising, before submitting, and on
  any resume, list the drafts and work from that list — never from memory. If ever unsure what
  has been drafted, run the list command and trust it over anything in context. On resume,
  also refresh diff state (see below) before drafting anything new.
- **Safe vs. gated.** Listing, editing, and deleting existing drafts are private and reversible.
  The only gated, irreversible actions are **`bulk_publish`** (submit — notifies everyone) and
  **`glab mr approve`**; never run either without explicit confirmation.

### Refreshing diff state

Inline drafts are pinned to the diff SHAs captured at review start. If the author pushes
new commits, those SHAs go stale.

- Refresh when: the user says **"refresh"**; creating an inline draft fails on its position;
  or **resuming a review session** (the MR may have changed since last time).
- On refresh: re-fetch `diff_refs` and the diff, and use the new SHAs for subsequent drafts.
- Refresh cannot re-pin drafts already created — they keep their original position and may
  show as outdated on publish. After refreshing, list existing drafts and, for any whose
  target lines moved, offer to delete and recreate them.

### Discarding

Drafts are private until published, so dropping them costs nothing and notifies no one.

- **Drop a single drafted comment:** delete it by id (see Commands). Do this freely whenever
  we change our mind about a comment.
- **Abandon the review:** delete all drafts (see Commands) for a clean slate.
- **Never** use `bulk_publish` to "clear" or "finish up" — publishing is the one action that
  makes everything public and notifies people. Discarding is always via delete.

## Workflow

1. **Identify the MR.** Accept a full MR URL or `<group>/<name> !<iid>`. A local clone is
   preferred but not required (clone-preferred).
   - **In a clone of the repo** → best: glab resolves the project from the git remote (`:id`
     works) and the surrounding code is on disk for context. A bare `!<iid>` is enough here.
   - **Not in a clone** → still works, as long as the project is identifiable from a URL or
     `<group>/<name>` slug. Derive the project full path (drop the host and `Sensorfact/`
     prefix gives the `~/repositories/` path; the full path for the API is
     `Sensorfact/<group>/<name>`). If neither a clone nor a slug identifies the project, stop and ask.
   - **Preflight auth:** `glab api user`. Don't trust `glab auth status` — it can report
     "logged in" while the token is invalid or lacks `api` scope. If `glab api user` errors,
     stop and ask the user to re-auth with an `api`-scoped token.
   - Set `$PROJECT` per the Commands section (`:id` in a clone, encoded full path otherwise).

2. **Gather context** (in a clone, run inside the repo dir; otherwise add `-R Sensorfact/<group>/<name>`):
   - `glab mr view $IID` — title, description, author, CI status, approvals
   - `glab mr view $IID --comments` — existing discussion, so we don't duplicate
   - `glab mr diff $IID` — the change

3. **Act only when asked.** Never comment or approve without explicit confirmation.

4. **Present Context** Present a high level summary of the MR to set the context
    - Show the title and description of the MR verbatim. 
    - Show the list of included commits, in oneline format. Expand to full commit description if asked.
    - If the given description of the MR is long, prompt for an optional summary.
    - Identify any structural concerns now, but **don't act on them yet**. Discuss these, and if agreed that they are a concern note these for discussion later. 

5. **Review Code Diffs with User.** Walk the diff. Surface line-level concerns as you go — things tied to a specific file and line; don't just summarize. If a broad/structural concern surfaces, note it for step 6 rather than drafting it here. Keep it a conversation — ask before moving on.
    - Show each part of the diff (chunk by file for large diffs).
    - When a concern is raised, follow the per-concern loop from the State model: propose one
      comment (`file:line — "text"`), wait for approval, then on approval create it immediately
      as an inline draft note (see Commands), confirm, and move on. One at a time.

6. **Discuss structural concerns** After walking the diff, discuss any broad concerns, including those raised during the context review. 
    - Same per-concern loop, but create these as general draft notes (no position).

7. **Summarise and Finish the review** 
    - List the drafts with `GET draft_notes` (the source of truth) and review them together.
    - Collaboratively write the MR review summary. Do not submit without approval.
    - Decide whether to approve the MR (separate from submitting — see step 8).

8. **Submit the review**
    - Only after explicit confirmation. Submit all drafts atomically via `bulk_publish`.
    - Approval is a separate, separately-confirmed action (`glab mr approve`).

## Commands

`$IID` is the MR internal id (the `!66` number). `$PROJECT` identifies the project and is set
once in step 1 depending on mode:

```bash
PROJECT=":id"                              # in a clone — glab resolves it from the git remote
PROJECT="Sensorfact%2F<group>%2F<name>"    # not in a clone — URL-encoded project full path
```

The `glab api` commands below use `projects/$PROJECT/...` and work unchanged in both modes.
The `glab mr` wrappers (`view`, `diff`, `approve`) don't take that path — when **not** in a
clone, add `-R Sensorfact/<group>/<name>`. Verified against glab 1.36.

**Gotchas (this glab version):**
- No `--jq` flag — pipe to `jq` instead.
- Inline draft notes need a nested JSON body via `--input -` **and** an explicit
  `-H "Content-Type: application/json"` header. Without the header you get a silent `HTTP 415`.
- `DELETE` returns an empty `204 No Content` — don't pipe it to `jq`; check the status with `-i`.

### Preflight (in step 1)
```bash
glab api user | jq '.username'    # fails outright if token invalid / lacks api scope
```

### Context (step 2)
```bash
glab mr view $IID                 # title, description, CI, approvals
glab mr view $IID --comments      # existing discussion (avoid duplicating)
glab mr diff $IID                 # the change

# SHAs needed for inline positions — capture once, reuse for the whole review
glab api "projects/$PROJECT/merge_requests/$IID" | jq '.diff_refs'
#  → { base_sha, head_sha, start_sha }

# Changed files / per-file diffs (to find addressable lines)
glab api "projects/$PROJECT/merge_requests/$IID/changes" \
  | jq -r '.changes[] | .new_path'
```

### Draft a general (non-inline) note
```bash
glab api --method POST "projects/$PROJECT/merge_requests/$IID/draft_notes" \
  -f note="your comment"
```

### Draft an inline note (pinned to a diff line)
The line must exist in the diff. Use `new_line` for an added/unchanged line; use `old_line`
(and omit `new_line`) for a removed line. `old_path`/`new_path` differ only for renames.
```bash
glab api --method POST "projects/$PROJECT/merge_requests/$IID/draft_notes" \
  -H "Content-Type: application/json" --input - <<JSON
{
  "note": "your inline comment",
  "position": {
    "position_type": "text",
    "base_sha": "$BASE_SHA",
    "head_sha": "$HEAD_SHA",
    "start_sha": "$START_SHA",
    "new_path": "path/to/file.py",
    "old_path": "path/to/file.py",
    "new_line": 62
  }
}
JSON
```

### List drafts — the source of truth / resume point
```bash
glab api "projects/$PROJECT/merge_requests/$IID/draft_notes" \
  | jq -r '.[] | "\(.id)\t\(.position.new_path // "(general)"):\(.position.new_line // "-")\t\(.note[0:60])"'
```

### Edit / delete a draft
```bash
glab api --method PUT "projects/$PROJECT/merge_requests/$IID/draft_notes/<DRAFT_ID>" \
  -f note="updated text"
glab api --method DELETE "projects/$PROJECT/merge_requests/$IID/draft_notes/<DRAFT_ID>" -i
```

### Delete all drafts (abandon the review)
```bash
glab api "projects/$PROJECT/merge_requests/$IID/draft_notes" \
  | jq -r '.[].id' \
  | xargs -I{} glab api --method DELETE "projects/$PROJECT/merge_requests/$IID/draft_notes/{}" -i
```

### Submit the review — irreversible, notifies everyone (gated)
```bash
glab api --method POST "projects/$PROJECT/merge_requests/$IID/draft_notes/bulk_publish"
```

### Approve — separate action, separately gated
```bash
glab mr approve $IID
```
