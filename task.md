# Art Critique Multi-Agent — Task Tracker

**Status legend:** `[ ]` todo · `[~]` in progress · `[x]` done · `[!]` blocked

---

## Developer Action Items
Tasks that require manual action outside of code changes.

- [x] **PAT-1** — Rotate the BobDogAgent Personal Access Token *(completed)*

- [x] **PAT-2** — Acquire Anthropic API Key and store in Firebase

  **Steps:**
  1. Go to https://console.anthropic.com and sign up or log in
  2. Navigate to **API Keys** in the left sidebar
  3. Click **Create Key** — name it something like `artwork-critique-prod`
  4. Copy the key immediately (it is only shown once)
  5. Store it in Firebase Secret Manager by running locally:
     ```bash
     firebase functions:secrets:set ANTHROPIC_API_KEY
     ```
     Paste the key when prompted. It is stored securely in Google Secret Manager
     and never written to any file or committed to the repo.
  6. Verify it was stored:
     ```bash
     firebase functions:secrets:access ANTHROPIC_API_KEY
     ```

  **Cost:** No monthly fee — pay-as-you-go only. At current usage estimates
  (~$0.004/session with Haiku), cost is negligible at low traffic.

- [x] **FB-1** — Upgrade Firebase project to Blaze (pay-as-you-go) plan

  Required before Cloud Functions can be deployed.
  Go to https://console.firebase.google.com → project `artwork-critique`
  → Spark plan badge (bottom left) → Upgrade to Blaze.

- [x] **FB-2** — Add `FIREBASE_TOKEN` secret to GitHub for CD pipeline

  This enables automatic deploys to Firebase Hosting on every merge to `main`.
  1. Run locally: `firebase login:ci`
  2. Copy the printed token
  3. Go to GitHub repo → Settings → Secrets and variables → Actions
  4. Add secret named `FIREBASE_TOKEN` with the copied value

---

## Milestone 1 — Project Scaffolding & Architecture Shell ✓
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
- [x] **1.6** Firebase project init completed — `firebase.json` and `.firebaserc` generated for project `artwork-critique`
- [x] **1.7** Smoke test passes: `flutter test` — 1/1 passing
- [x] **1.8** GitHub Actions CI/CD workflows added (`.github/workflows/`)

---

## Milestone 2 — Cloud Function Proxy
**Goal:** A deployed Firebase Cloud Function that accepts a base64 image + persona ID, calls Claude, and returns a critique string. API key never touches the client.

**Demonstrates:** Direct `curl` or Postman POST to the function URL returns a valid critique from each of the three personas.

### Tasks
- [x] **2.1** Define the three system prompts server-side in `functions/index.js`
- [x] **2.2** Write HTTP Cloud Function:
  - Accepts `{ imageBase64: string, personaId: 'buyer' | 'admirer' | 'skeptic' }`
  - Validates input, maps persona ID to system prompt
  - Calls Claude Haiku 4.5 vision API with `max_tokens: 500`
  - Returns `{ critique: string }`
- [x] **2.3** Anthropic API key stored in Firebase Secret Manager
- [x] **2.4** `maxInstances: 10` set via `setGlobalOptions` for cost control
- [x] **2.5** Function deployed: `https://critique-t26hrklwwa-uc.a.run.app`
  - Note: 2nd gen Cloud Functions use Cloud Run URLs, not cloudfunctions.net
  - Public invocation enabled via `roles/run.invoker` on `allUsers`
  - Artifact cleanup policy set (1-day retention) to limit storage costs
- [x] **2.6** Smoke test passed — all three personas return valid critiques via curl
- [x] **2.7** Update this file — mark completed tasks

---

## Milestone 3 — Flutter Domain & Data Layer + BLoC ✓
**Goal:** Full state management pipeline wired up with stubbed/mocked repository. Verified through unit tests.

**Note:** All domain and data layer code was built alongside Milestone 1 scaffolding.

### Tasks
- [x] **3.1** Domain entities: `Artwork`, `PersonaCritique`, `PersonaId`
- [x] **3.2** Repository interface: `CritiqueRepository`
- [x] **3.3** Use case: `GetAllCritiques` — calls repository 3× via `Future.wait`
- [x] **3.4** Data model + mapper: `CritiqueResponseModel`
- [x] **3.5** `CritiqueRepositoryImpl` — HTTP POST to Cloud Function URL
- [x] **3.6** All dependencies registered in `get_it` injection container
- [x] **3.7** `CritiqueBloc` with `UploadArtworkAndCritique` event and `Initial/Loading/Loaded/Error` states
- [ ] **3.8** Write unit tests (`test/features/critique/`):
  - Mock repository with `mocktail`
  - Test all BLoC state transitions
  - Test use case with stubbed repository

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
- [ ] **4.4** Implement image picker — encodes selected image to base64
- [ ] **4.5** Handle error state display (snackbar or inline error card)
- [ ] **4.6** Write widget tests:
  - Upload button triggers `UploadArtworkAndCritique` event
  - Loading state renders shimmers
  - Loaded state renders three `PersonaCritiqueCard` widgets with correct text
  - Error state renders error message
- [ ] **4.7** Write headless integration test (`integration_test/`) with stubbed repo:
  - Full flow: image select → loading → critiques rendered
- [ ] **4.8** Update this file — mark completed tasks

---

## Milestone 5 — Integration & Deployment
**Goal:** Live, shareable app deployed to Firebase Hosting. All three personas return real Claude critiques for uploaded artwork.

**Demonstrates:** Public Firebase Hosting URL loads the app; uploading an image returns critiques from all three personas within a reasonable time.

### Tasks
- [ ] **5.1** Build Flutter web: `flutter build web --release`
- [ ] **5.2** Deploy to Firebase Hosting: `firebase deploy --only hosting`
- [ ] **5.3** End-to-end smoke test on live URL — upload an image, verify all three critiques return
- [ ] **5.4** Verify API key is never present in built JS bundle (browser devtools check)
- [ ] **5.5** Add `FIREBASE_TOKEN` GitHub secret to enable automatic CD deploys (see FB-2)
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
