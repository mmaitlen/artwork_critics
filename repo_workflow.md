# Repository Workflow

This file defines the branching, commit, and PR conventions for this project.
It is intended to be read and followed by any agent or contributor working in this repo.

---

## Accounts & Authentication

- **Primary developer:** the human owner of this repo
- **Agent account:** [BobDogAgent](https://github.com/BobDogAgent) — all agent-authored branches and PRs are pushed and opened from this account
- Agents must configure `gh` CLI and `git` credentials to use the BobDogAgent PAT before pushing or creating PRs

---

## Branch Strategy

- **`main` is protected.** No direct commits or pushes to `main` ever.
- All work happens on feature/milestone branches.
- One branch per milestone (or logical unit of work if scope expands beyond milestones).

### Branch naming

```
feature/milestone-<number>-<short-slug>
```

Examples:
- `feature/milestone-1-scaffolding`
- `feature/milestone-2-cloud-function`
- `feature/milestone-3-domain-layer`

### Creating a branch

```bash
git checkout main
git pull origin main
git checkout -b feature/milestone-<number>-<slug>
git push -u origin feature/milestone-<number>-<slug>
```

---

## Commit Conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

Examples:
```
feat(critique): add CritiqueBloc with loading and error states
test(critique): add BLoC unit tests with mocked repository
chore(deps): add flutter_bloc and get_it to pubspec.yaml
```

Rules:
- Subject line ≤ 72 characters
- Use present tense ("add" not "added")
- One logical change per commit — avoid mega-commits
- Never `--no-verify` to skip hooks

---

## Pull Requests

### When to open a PR
Open a PR when a milestone is fully complete:
- All milestone tasks checked off in `task.md`
- All tests passing (`flutter test`)
- No known regressions

### PR process

1. Push the milestone branch to origin
2. Open a PR targeting `main` using the `gh` CLI:
   ```bash
   gh pr create \
     --title "Milestone N: <title>" \
     --body "$(cat <<'EOF'
   ## Summary
   - <bullet points of what was built>

   ## Milestone tasks completed
   - [x] task 1
   - [x] task 2

   ## Test plan
   - [ ] `flutter test` passes (N/N)
   - [ ] Manual smoke test on web

   🤖 Authored by BobDogAgent via Claude Code
   EOF
   )"
   ```
3. **Do not merge.** Wait for the repo owner to review and approve.
4. After approval, the repo owner merges using **squash and merge**.
5. After merge, delete the branch:
   ```bash
   git push origin --delete feature/milestone-<number>-<slug>
   git branch -d feature/milestone-<number>-<slug>
   ```

---

## Code Review Expectations

- Agents should self-review before opening a PR: no debug prints, no dead code, no placeholder TODOs unless explicitly tracked in `task.md`
- Tests must pass before a PR is opened — do not open a PR with failing tests
- PRs should be scoped to a single milestone; do not bundle multiple milestones into one PR

---

## Protecting `main`

Recommended branch protection rules to configure in GitHub repo settings:

- Require pull request before merging
- Require at least 1 approval
- Dismiss stale pull request approvals when new commits are pushed
- Do not allow bypassing the above settings

---

## Task Tracking

- `task.md` in the repo root is the source of truth for milestone progress
- Mark tasks `[x]` as they complete
- Update `task.md` as part of the milestone branch — include task updates in the same PR as the work

---

## Key Files

| File | Purpose |
|---|---|
| `spec.md` | Product and architecture specification |
| `task.md` | Milestone task tracker — updated by agents |
| `questions.md` | Async Q&A between agent and repo owner |
| `repo_workflow.md` | This file — branching and PR conventions |

---

## Reusing This Workflow in Other Projects

1. Copy this file to the new project root
2. Update the **Accounts & Authentication** section with the relevant agent account
3. Update branch naming if the project uses a different structure (e.g., `feature/` instead of `milestone/`)
4. Adjust merge strategy to project preference
5. Everything else applies as-is
