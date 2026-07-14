# Mercury

Mercury is a small Node.js/OpenAI reference project with command-line examples for chat and code-generation flows behind a lightweight role-based access gate.

## Requirements

- Node.js 18 or newer
- npm
- An OpenAI API key provided through `OPENAI_API_KEY`

## Installation

```bash
npm install
```

## Configuration

Set your API key before running an example:

```bash
export OPENAI_API_KEY=<your-api-key>
```

Optional model overrides are available when you want to test a different supported model without changing source code:

```bash
export OPENAI_CHAT_MODEL=gpt-4.1-mini
export OPENAI_CODE_MODEL=gpt-4.1-mini
```

Mercury is a small private Node.js reference project that demonstrates how to run OpenAI-powered command-line examples behind a lightweight role-based access gate. It currently includes two CLI modes:

- `chat`: sends a conversational prompt to a chat-completions model.
- `codex`: sends a code-generation style prompt to a completions model.

- Enable all-access mode for local development:

```bash
export ALL_ACCESS=true
export OPENAI_API_KEY=<your-api-key>
npm run chat -- "Explain recursion"
```

## Access and Permissions

`src/access.js` centralizes the permission model. The built-in roles are:

- `admin`: has every permission through `*`.
- `user`: has `chat.run` and `codex.run`.
- `guest`: has no permissions.

Mode runners call `ensurePermission(...)` before making API requests. Permission failures are handled at the user-facing boundary and printed as clear `ERROR:` messages instead of stack traces.

## Architecture

The request flow is deliberately linear:

1. `src/index.js` parses the command-line mode and prompt.
2. `src/index.js` verifies `OPENAI_API_KEY` is present.
3. `src/index.js` dispatches to `runChatExample(...)` or `runCodexExample(...)`.
4. The selected runner prints a short banner and echoes the prompt.
5. The runner calls `ensurePermission(...)` with the mode-specific permission.
6. If access is allowed, the runner calls the OpenAI SDK.
7. The runner prints the first response choice, falling back to a deterministic placeholder when no content is returned.

### Entry Point

`src/index.js` is the only executable entry point. Keep new modes wired through this file unless the CLI is intentionally restructured.

### Mode Runners

`src/chat.js` and `src/codex.js` follow the same pattern: construct an OpenAI client from `OPENAI_API_KEY`, check permissions, call the relevant SDK endpoint, and print a concise result.

### Access Control

`src/access.js` exports:

- `can(permission, user)`: returns a boolean for permission checks.
- `ensurePermission(permission, user)`: throws an `E_PERMISSION` error when access is denied.
- `currentUser()`: derives the current user role from environment variables.

## Developer Guide

### Local Validation

There is no formal test suite yet. Use syntax checks and Git checks before committing:

```bash
node --check src/index.js
node --check src/access.js
node --check src/chat.js
node --check src/codex.js
git diff --check
```

Run API-backed examples only when you have a valid API key and want to exercise live behavior:

```bash
ALL_ACCESS=true OPENAI_API_KEY=<your-api-key> npm run chat -- "Explain recursion"
ALL_ACCESS=true OPENAI_API_KEY=<your-api-key> npm run codex -- "Generate a JavaScript function to sort an array"
```

### Adding a New CLI Mode

1. Create a focused runner in `src/<mode>.js` with a named export.
2. Use native ESM imports with explicit `.js` file extensions.
3. Construct the OpenAI client from `process.env.OPENAI_API_KEY` or a shared helper if one is introduced.
4. Add a mode-specific permission such as `<mode>.run`.
5. Gate execution with `ensurePermission(...)` and handle `err.code === "E_PERMISSION"` at the runner boundary.
6. Wire the mode into `src/index.js` and update the usage output.
7. Document the mode, permission, and command in this README and in `AGENTS.md` when contributor guidance changes.
8. Run syntax checks and `git diff --check`.

### Coding Conventions

- Use native ECMAScript modules.
- Prefer named exports for project utilities and runners.
- Keep modules small and focused.
- Use `const` unless reassignment is required.
- Keep CLI output concise and actionable.
- Do not wrap imports in `try`/`catch` blocks.
- Do not hard-code credentials, tokens, organization IDs, project IDs, or personal data.

### Dependency Guidelines

- Add runtime dependencies only when they directly support project behavior.
- Add development dependencies only when they provide a clear validation or maintenance benefit.
- Commit `package-lock.json` when npm creates or updates it.
- Never commit `node_modules/`.

## Troubleshooting

## Commands

Run the chat example:

```bash
npm run chat -- "Explain recursion in simple terms"
```

Run the code-generation example:

```bash
npm run codex -- "Generate a JavaScript function to sort an array"
```

Both examples use the OpenAI Responses API and print deterministic fallback text when the API returns no generated content.
