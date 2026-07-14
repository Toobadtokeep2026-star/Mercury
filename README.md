# Mercury

Mercury is a small private Node.js/OpenAI reference project with command-line examples for chat and code-generation style flows behind a lightweight role-based access gate.

## Requirements

- Node.js 18 or newer
- npm
- An OpenAI API key provided with `OPENAI_API_KEY`

## Setup

```bash
npm install
export OPENAI_API_KEY=<your-api-key>
```

## Usage

```bash
npm run chat -- "Explain recursion"
npm run codex -- "Generate a JavaScript function to sort an array"
```

Enable all-access mode for local development:

```bash
ALL_ACCESS=true OPENAI_API_KEY=<your-api-key> npm run chat -- "Explain recursion"
```

Alternatively set a role via `USER_ROLE` (default: `user`). Roles and permissions can be overridden with `ROLES_JSON` (JSON map).

## Performance Optimizations

Mercury keeps the CLI intentionally small, but startup behavior still matters for responsiveness and battery efficiency. The current implementation includes these optimizations:

| Optimization | Where | Expected impact |
| --- | --- | --- |
| Lazy mode loading | `src/index.js` imports only the runner for the requested mode after validating the command and prompt. | Faster help/error paths because they avoid loading mode modules or the OpenAI SDK; lower short-lived memory use for invalid invocations. |
| Deferred OpenAI SDK import | `src/chat.js` and `src/codex.js` import `openai` only after permission checks pass. | Denied requests return faster, allocate less memory, and avoid unnecessary module initialization work. |
| On-demand OpenAI client construction | `src/chat.js` and `src/codex.js` create the client only when an API call will be made. | Reduces startup allocations and avoids keeping SDK/client objects alive during access-denied runs. |
| Early CLI validation | `src/index.js` prints usage before checking `OPENAI_API_KEY` when the command is incomplete or unknown. | Improves responsiveness for help-like invocations and avoids unnecessary environment validation work. |
| Cached `ROLES_JSON` parsing | `src/access.js` reuses the parsed role map while the environment value is unchanged. | Avoids repeated JSON parsing during multiple permission checks in one process, reducing CPU work and transient allocations. |
| Dynamic environment reads | `src/access.js` reads `USER_ROLE` and `ALL_ACCESS` when checks run instead of freezing them at module load. | Keeps behavior correct for long-running or embedded use without adding startup state or reload work. |

## Validation

Use syntax checks for changed JavaScript files without calling external APIs:

```bash
node --check src/index.js
node --check src/access.js
node --check src/chat.js
node --check src/codex.js
git diff --check
```
