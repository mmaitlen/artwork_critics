# Art Critique Multi-Agent — Task Tracker

**Status legend:** `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked

---

## Developer Action Items
Tasks that require manual action outside of code changes.

- [ ] **PAT-1** — Rotate the BobDogAgent Personal Access Token
  The BobDogAgent PAT was entered into `questions.md` during setup. GitHub's push protection caught it before it reached the remote, and the token was redacted from the commit. However, the token was briefly exposed in plaintext in a local file and should be considered compromised.

  **Steps:**
  1. Log into the BobDogAgent GitHub account
  2. Go to Settings → Developer settings → Personal access tokens → Tokens (classic)
  3. Regenerate (rotate) the token — keep the same scopes: `repo`, `workflow`
  4. Update the local git remote with the new token:
     ```bash     
     git remote set-url bobdog https://BobDogAgent:<NEW_TOKEN>@github.com/mmaitlen/artwork_critics.git
     ```
  5. Do not paste the new token into any tracked file — `.git/config` only

---

## Milestone 1 — Project Scaffolding & Architecture Shell
**Goal:** Empty Flutter web app with correct folder structure, dependencies, and Firebase project wired up. No counter app boilerplate.

**Demonstrates:** App compiles and runs on web (`flutter run -d chrome`), blank placeholder screen loads, `flutter test` passes with zero failures.

### Tasks
- [x] **1.1** Create Flutter project with `flutter create --platforms web` (no counter app)
- [x] **1.2** Set up Clean Architecture folder structure:
  ```
  lib/
    core/           # DI, router, theme, error types
    features/
      critique/
        domain/     # entities, repository interfaces, use cases
        data/       # repository impl, API client, models
        presentation/ # BLoC, pages, widgets
  ```
- [x] **1.3** Add and configure dependencies in `pubspec.yaml`:
  - `flutter_bloc`, `equatable` — state management
  - `get_it` — dependency injection
  - `go_router` — navigation
  - `image_picker` — image selection (web-compatible)
  - `http` — Cloud Function calls
  - `mocktail`, `bloc_test` — test utilities
- [x] **1.4** Configure `get_it` service locator (`core/di/injection.dart`)
- [x] **1.5** Configure `go_router` with initial placeholder route (`core/router/app_router.dart`)
- [!] **1.6** Firebase project init — **manual step required by developer**:
  ```bash
  firebase login          # opens browser
  firebase init           # select: Hosting, Functions (Node.js 20)
  ```
  When prompted: public directory = `build/web`, single-page app rewrite = yes, Functions language = JavaScript
- [x] **1.7** Smoke test passes: `flutter test` — 1/1 passing
- [x] **1.8** Update this file — mark completed tasks

> **Note on 1.6:** Firebase init requires user interaction (browser login). See instructions below.

---

## Milestone 2 — Cloud Function Proxy
**Goal:** A deployed Firebase Cloud Function that accepts a base64 image + persona ID, calls Claude, and returns a critique string. API key never touches the client.

**Demonstrates:** Direct `curl` or Postman POST to the function URL returns a valid critique from each of the three personas.

### Tasks
- [ ] **2.1** Define the three system prompts server-side in `functions/src/prompts.js`:
  - `buyer` — enthusiastic, collector/investment lens, wants to own it
  - `admirer` — emotionally engaged, genuine appreciation
  - `skeptic` — dismissive, "my 5th grader could do that" energy
- [ ] **2.2** Write `functions/src/critique.js` — HTTP callable function:
  - Accepts `{ imageBase64: string, personaId: 'buyer' | 'admirer' | 'skeptic' }`
  - Validates input, maps persona ID to system prompt
  - Calls Claude vision API with `max_tokens: 500`
  - Returns `{ critique: string }`
- [ ] **2.3** Store Anthropic API key in Firebase environment config:
  ```
  firebase functions:secrets:set ANTHROPIC_API_KEY
  ```
- [ ] **2.4** Set `maxInstances: 10` on function to cap runaway costs
- [ ] **2.5** Deploy function: `firebase deploy --only functions`
- [ ] **2.6** Smoke test with curl — verify all three persona IDs return valid responses
- [ ] **2.7** Update this file — mark completed tasks

> **Blocker:** Requires Anthropic API key (Q3) and Firebase Blaze plan (Q2).

---

## Milestone 3 — Flutter Domain & Data Layer + BLoC
**Goal:** Full state management pipeline wired up with stubbed/mocked repository. No UI yet — verified entirely through unit tests.

**Demonstrates:** Unit test suite passes, covering:
- BLoC state transitions: `initial → loading → critiquesLoaded`
- BLoC error path: `initial → loading → critiqueError`
- Each persona result mapped correctly to domain entity

### Tasks
- [ ] **3.1** Define domain entities (`domain/entities/`):
  - `Artwork` — holds image bytes + display name
  - `PersonaCritique` — persona ID, persona label, critique text
- [ ] **3.2** Define repository interface (`domain/repositories/critique_repository.dart`):
  - `Future<PersonaCritique> getCritique(Artwork artwork, PersonaId persona)`
- [ ] **3.3** Define use case (`domain/usecases/get_all_critiques.dart`):
  - Calls repository 3× (one per persona), returns `List<PersonaCritique>`
- [ ] **3.4** Implement data model + mapper (`data/models/critique_response_model.dart`)
- [ ] **3.5** Implement `CritiqueRepositoryImpl` — HTTP POST to Cloud Function URL
- [ ] **3.6** Register all dependencies in `get_it` injection container
- [ ] **3.7** Implement `CritiqueBloc`:
  - Events: `UploadArtworkAndCritique(Artwork)`
  - States: `CritiqueInitial`, `CritiqueLoading`, `CritiqueLoaded(List<PersonaCritique>)`, `CritiqueError(String)`
- [ ] **3.8** Write unit tests (`test/features/critique/`):
  - Mock repository with `mocktail`
  - Test all BLoC state transitions
  - Test use case with stubbed repository
- [ ] **3.9** Update this file — mark completed tasks

---

## Milestone 4 — Flutter UI
**Goal:** Full app UI wired to the BLoC. Image picker, three critique panels, loading and error states.

**Demonstrates:** Widget tests and a headless integration test demonstrating the full user flow (select image → loading state → three critiques displayed) using a stubbed repository. No live network calls needed.

### Tasks
- [ ] **4.1** Build `CritiquePage` layout:
  - Image preview area (top)
  - "Upload Artwork" button
  - Three critique panels (one per persona) — label, critique text, loading shimmer
- [ ] **4.2** Build `PersonaCritiqueCard` widget:
  - Persona name + role label
  - Critique text (scrollable)
  - Loading and error states
- [ ] **4.3** Connect `CritiqueBloc` to UI via `BlocBuilder`/`BlocListener`
- [ ] **4.4** Implement image picker (`image_picker_web`) — encodes selected image to base64
- [ ] **4.5** Handle error state display (snackbar or inline error card)
- [ ] **4.6** go_router: ensure routing is clean, no dead routes
- [ ] **4.7** Write widget tests:
  - Upload button triggers `UploadArtworkAndCritique` event
  - Loading state renders shimmers
  - Loaded state renders three `PersonaCritiqueCard` widgets with correct text
  - Error state renders error message
- [ ] **4.8** Write headless integration test (`integration_test/`) with stubbed repo:
  - Full flow: image select → loading → critiques rendered
- [ ] **4.9** Update this file — mark completed tasks

---

## Milestone 5 — Integration & Deployment
**Goal:** Live, shareable app deployed to Firebase Hosting. All three personas return real Claude critiques for uploaded artwork.

**Demonstrates:** Public Firebase Hosting URL loads the app; uploading an image returns critiques from all three personas within a reasonable time.

### Tasks
- [ ] **5.1** Wire `CritiqueRepositoryImpl` to live Cloud Function URL (via `const` in `core/config/`)
- [ ] **5.2** Build Flutter web: `flutter build web --release`
- [ ] **5.3** Deploy to Firebase Hosting: `firebase deploy --only hosting`
- [ ] **5.4** End-to-end smoke test on live URL — upload an image, verify all three critiques return
- [ ] **5.5** Verify API key is never present in built JS bundle (browser devtools check)
- [ ] **5.6** Update this file — mark all tasks complete, record live URL

---

## Deferred (Post-MVP)
- Round table / debate mode
- Persona avatars
- Saving/sharing sessions
- Firestore persistence
- Multiple artwork comparison

---

## Live URL
> (populated after Milestone 5)

## Blockers / Notes
- Firebase Blaze plan required before deploying Cloud Functions (Milestone 2)
- Anthropic API key required before Milestone 2 — see questions.md Q3 for setup instructions
- Model to use: pending Q5 answer in questions.md (defaulting to `claude-haiku-4-5` unless overridden)
