**PROJECT: Art Critique Multi-Agent Flutter Web App**

**Concept:** A Flutter web app where users upload an image of their artwork and three AI personas critique it using Claude's vision API. The personas have distinct personalities and speak directly to the specific qualities of the uploaded work.

**The Three Personas:**

1. **The Buyer** — enthusiastic, sees investment/collector value, asks about pricing and provenance, wants to own it
2. **The Admirer** — genuine appreciation, emotionally engaged, loves the work but can't afford it or isn't in the market
3. **The Skeptic** — dismissive, "my 5th grader could do that" energy, challenges the value of abstract/contemporary work

**Tech Stack:**

- Flutter web (frontend)
- Firebase Hosting (deployment)
- Firebase Cloud Functions (API proxy — Claude API key never touches the client)
- Claude API with vision (claude-sonnet-4-20250514, multi-turn capable)

**Architecture:**

- User selects/uploads image in Flutter → encoded to base64 client-side
- Flutter sends base64 image + persona identifier to Firebase Cloud Function
- Cloud Function holds all system prompts server-side, calls Claude API, returns response
- Three personas called sequentially, each receiving the same image
- Conversation history maintained client-side for potential follow-up turns
- Structure code using a Clean architecture
- Use BLoC for state management
- Use get_it for dependency injection
- Use go_router for navigation

**API Key Security:**

- Anthropic API key stored in Firebase environment config
- Never exposed to client
- All Claude calls proxied through Cloud Functions

**MVP Scope (build this first):**

- Single image upload
- Three personas give initial critique sequentially
- Clean, functional UI — image display + three critique panels
- Deployed and shareable via Firebase Hosting URL

**Deferred to polish phase:**

- Round table / debate mode (personas respond to each other)
- Persona avatars or visual identity
- Saving/sharing critique sessions
- Firestore persistence
- Multiple artwork comparison

**Build Order:**

1. Flutter project setup + Firebase init (Hosting + Functions)
2. Write and deploy Cloud Function proxy (receives base64 + persona ID, calls Claude, returns response)
3. Test Cloud Function directly via Postman before touching Flutter UI
4. Build Flutter UI — image picker, three critique panels
5. Wire Flutter to Cloud Function
6. Deploy to Firebase Hosting

**Notes:**

- System prompts live in the Cloud Function, not the Flutter client
- This is a portfolio piece targeting a Senior Android/Mobile Engineer application at Anthropic — code quality and architecture matter
- Developer is a Senior Flutter Engineer with strong mobile background, comfortable with BLoC state management
- Keep the UI clean but not precious for MVP — function over form until polish phase
- create a task.md file before building code that creates milestones, each milestone ends with a demonstrative set of features.  The demonstration could be around tests or workflows using an actual UI.
- track the tasks completed so future agents can pick up if multiple sessions are needed.
- tests should be created that ensure tasks are completed and not breaking common workflows.  Headless tests should be prioritized that drive the state management utilizing stubbed or mocked repositories to stand in for actual implementations of the backend components and UI.
- Speed of development is important, but correctness and code cleanliness is paramount. I want to be able to scope an demonstrative MVP ASAP, but I want it to be good enough to use as a showcase in my job application submission to Anthropic.
- start with an empty flutter project scaffolding instead of the default Flutter counter application