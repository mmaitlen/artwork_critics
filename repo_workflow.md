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

### Pre-PR checklist
Run both checks and fix all issues before opening a PR. Do not open a PR with failures or lint warnings.

```bash
flutter analyze   # zero issues required
flutter test      # all tests must pass
```

### When to open a PR
Open a PR when a milestone is fully complete:
- All milestone tasks checked off in `task.md`
- `flutter analyze` — zero issues
- `flutter test` — all tests passing
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
- `flutter analyze` must report zero issues — do not open a PR with lint warnings or errors
- `flutter test` must pass — do not open a PR with failing tests
- PRs should be scoped to a single milestone; do not bundle multiple milestones into one PR

---

## Protecting `main`

Recommended branch protection rules to configure in GitHub repo settings:

- Require pull request before merging
- Require at least 1 approval
- Dismiss stale pull request approvals when new commits are pushed
- Do not allow bypassing the above settings

---

## CI/CD (GitHub Actions)

### CI — `.github/workflows/ci.yml`
Runs on every PR targeting `main`. Blocks merge if any step fails.
- `flutter analyze` — zero issues required
- `flutter test` — all tests must pass

### CD — `.github/workflows/cd.yml`
Runs on every push to `main` (i.e. after a PR is merged).
- Builds `flutter build web --release`
- Deploys to Firebase Hosting (disabled until Firebase is configured)

### Enabling Firebase deploy
Once Firebase project is initialized, add two secrets to the repo:

| Secret | How to get it |
|---|---|
| `FIREBASE_TOKEN` | Run `firebase login:ci` locally, copy the printed token |
| `FIREBASE_PROJECT_ID` | Your Firebase project ID (e.g. `artwork-critics-12345`) |

Add at: **GitHub repo → Settings → Secrets and variables → Actions → New repository secret**

Then uncomment the deploy step in `.github/workflows/cd.yml`.

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
