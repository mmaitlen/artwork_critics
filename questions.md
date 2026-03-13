# Questions

Answer these before construction begins. I'll check this file and proceed once all are answered.

---
# Round 1
## Pre-Build Blockers

**Q1. Firebase project**
Do you have an existing Firebase project to connect this to, or should we create a new one? If existing, what's the project ID?

> A: we'll create a new one

---

**Q2. Firebase billing plan**
Cloud Functions require the Blaze (pay-as-you-go) plan. Is your Firebase project already on Blaze, or do you need to upgrade first?

> A: i'll upgrade to Blaze after it's created

---

**Q3. Anthropic API key**
You'll need an API key stored in Firebase config before the Cloud Function can call Claude. Do you have one ready? (I don't need the key itself — just confirming it's available so we don't hit a blocker at step 2 of the build order.)

> A: I don't have one at the moment.  I'll need instructions on how to create it.  Is there a cost involved with this?

---

## Clarifications

**Q4. Claude model ID**
The spec references `claude-sonnet-4-20250514` which appears to be a placeholder. The current correct ID is `claude-sonnet-4-6`. Should I use `claude-sonnet-4-6`, or do you want a specific model version?

> A: I don't have a specific model, but if there's a price difference i'd like to go with a cheaper model

## Notes from questions
- From the questions answered I realize that cost is a consideration for me, I'd like to keep this project as cheap as possible.  If there's a way to restrict token usage if that helps keep any surprise charges in hand I'd like to do so.  I don't expect there to be a lot of usage, but I don't want any surprises if someone stumbles upon the site.

---

# Round 2

## Cost Breakdown & Decisions

**Anthropic API Key**
- Create a free account at https://console.anthropic.com
- Navigate to "API Keys" and generate a key
- Cost: **no monthly fee** — pure pay-as-you-go based on tokens used

**Model Recommendation: `claude-haiku-4-5` (cheapest with vision)**

| Model | Input | Output | Cost per session* |
|---|---|---|---|
| claude-haiku-4-5 | $0.80/MTok | $4/MTok | ~$0.004 |
| claude-sonnet-4-6 | $3/MTok | $15/MTok | ~$0.016 |

*3 persona calls, ~1,000 input tokens + 500 output tokens each

**Cost Safeguards built into the Cloud Function:**
- `max_tokens: 500` per Claude call — caps output cost hard
- Firebase Functions `maxInstances: 10` — limits concurrent executions
- All three calls cost under $0.02 even on Sonnet; under $0.005 on Haiku

**Q5. Model confirmation**
Given the above, I recommend `claude-haiku-4-5` for cost efficiency. Quality will still be good for personality-driven critiques. Confirm or override?

> A: Looks good, let's use haiku-4-5

---

# Round 3 — git_questions

**Q6. GitHub repo URL**
What is the full GitHub repo URL? (e.g., `https://github.com/your-username/repo-name`) — needed to configure the `gh` CLI for creating PRs.

> A: https://github.com/mmaitlen/artwork_critics

---

**Q7. BobDogAgent authentication**
For me to push branches and open PRs *as* the BobDogAgent account, I need a Personal Access Token (PAT) for that account.

- Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
- Generate a token with scopes: `repo`, `workflow`
- Paste the token here (or let me know if you'd prefer to set it another way)

> A: [REDACTED — token configured in local .git/config only, never commit tokens to the repo]

---

**Q8. Branch naming convention**
How should milestone branches be named? Options:
- `milestone/1-scaffolding` (recommended — clear and hierarchical)
- `milestone-1`
- `feature/milestone-1-scaffolding`
- Other?

> A: `feature/milestone-1-scaffolding`

---

**Q9. PR merge strategy**
When you approve and merge a PR, which merge strategy should I configure as the default?
- **Squash and merge** (recommended — keeps main history clean, one commit per milestone)
- **Merge commit** (preserves full branch history)
- **Rebase and merge**

> A: Squash and merge

---

**Q10. PR reviewers / labels**
Should PRs be auto-assigned to your GitHub account for review, or will you just find them in the repo? Any labels you want applied (e.g., `milestone`, `ready-for-review`)?

> A: Assign them to me and use any labels that seem relevant 
