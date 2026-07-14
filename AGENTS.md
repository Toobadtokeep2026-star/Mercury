# AGENTS.md — Mercury Repository Guide

This file is the first place future Codex sessions should read before changing this repository. It documents the current project shape, expected conventions, architecture, and workflow. The instructions in this file apply to the entire repository tree rooted here.

## Project Overview

Mercury is a small private Node.js/OpenAI reference project. It provides command-line examples for invoking OpenAI-powered chat and code-generation style flows behind a lightweight role-based access gate.

Current repository characteristics:

- Runtime: Node.js 18 or newer.
- Module system: native ECMAScript modules (`"type": "module"` in `package.json`).
- Package manager: npm.
- Main entry point: `src/index.js`.
- OpenAI SDK dependency: `openai` npm package.
- OpenAI API style: Responses API for both chat and code-generation examples.
- Primary use case: runnable CLI examples for `chat` and `codex` modes.

## Repository Layout

```text
.
├── AGENTS.md          # Instructions for Codex and future agent sessions
├── README.md          # Human-facing project overview and usage examples
├── package.json       # npm scripts, dependency declarations, Node engine
└── src/
    ├── access.js      # Role/permission helpers used by CLI modes
    ├── chat.js        # Chat completion example runner
    ├── codex.js       # Code-generation style example runner
    └── index.js       # CLI argument parsing, usage output, mode dispatch
```

## Architecture

### CLI Entry Point

`src/index.js` is the only executable application entry point today. It:

1. Imports the mode runners from `src/chat.js` and `src/codex.js`.
2. Parses command-line arguments in the form `npm run <mode> -- <prompt>`.
3. Requires `OPENAI_API_KEY` before doing any work.
4. Prints usage information when no prompt is supplied or an unknown mode is requested.
5. Dispatches to the requested async runner via top-level `await`.

### Access Control Layer

`src/access.js` centralizes the project’s simple permission model.

- `DEFAULT_ROLE` comes from `USER_ROLE` and falls back to `user`.
- `ALL_ACCESS=true` bypasses permission checks and is intended for local development.
- Built-in roles are:
  - `admin`: all permissions via `*`.
  - `user`: `chat.run` and `codex.run`.
  - `guest`: no permissions.
- `ROLES_JSON` may override the role map with a JSON object.
- Public exports are:
  - `can(permission, user)` for boolean checks.
  - `ensurePermission(permission, user)` for throwing checks.
  - `currentUser()` for deriving the current role from the environment.

### OpenAI Mode Runners

`src/chat.js` and `src/codex.js` follow the same pattern:

1. Construct an `OpenAI` client from `process.env.OPENAI_API_KEY`.
2. Print a short banner and prompt echo.
3. Call `ensurePermission(...)` with the mode-specific permission.
4. If access is denied, print a user-facing error and return without throwing.
5. Call the OpenAI Responses API.
6. Extract and print `response.output_text` with a fallback string when no content is returned.

Keep new mode runners consistent with this pattern unless intentionally refactoring the CLI architecture.

## Coding Standards

### JavaScript Style

- Use native ESM syntax: `import` and `export`.
- Include explicit relative file extensions in imports, e.g. `./access.js`.
- Prefer small, focused modules with named exports.
- Use `const` by default; use `let` only when reassignment is required.
- Prefer clear function names that describe behavior (`runChatExample`, `ensurePermission`).
- Use optional chaining and nullish coalescing where they make response handling safer.
- Keep console output concise and actionable because this is a CLI-oriented project.
- Do not add `try`/`catch` around imports.

### Error Handling

- Permission failures should use `ensurePermission` and check for `err.code === "E_PERMISSION"` at user-facing boundaries.
- User-facing CLI failures should print clear `ERROR:` messages.
- Do not swallow unexpected errors; rethrow them after handling known cases.
- Prefer deterministic fallback output for optional API response fields.

### Configuration

- Read runtime configuration from environment variables.
- Do not hard-code credentials, tokens, API keys, organization IDs, project IDs, or personal data.
- Keep `.env` files untracked; `.gitignore` already excludes `.env`.
- If documentation needs an API key example, use placeholders such as `sk-proj-...` or `<your-api-key>` only.

### OpenAI API Usage

- Keep model names, endpoints, and SDK usage easy to update.
- `OPENAI_CHAT_MODEL` and `OPENAI_CODE_MODEL` may override the default model for the chat and code-generation examples.
- If changing OpenAI APIs, verify against official OpenAI documentation because model availability and SDK interfaces can change.
- Avoid adding compatibility wrappers unless the project grows enough to justify them.
- Prefer explicit request parameters so examples are readable.

## Testing and Validation

There is currently no formal test suite in `package.json`. Until tests are added, validate changes with the strongest available checks:

1. `npm install` if dependencies are absent.
2. `npm run chat -- "<prompt>"` when validating chat behavior and a valid `OPENAI_API_KEY` is available.
3. `npm run codex -- "<prompt>"` when validating code-generation behavior and the configured model/API remains available.
4. `node --check src/index.js` plus checks for any changed JavaScript files to catch syntax errors without calling external APIs.
5. `git diff --check` before committing to catch whitespace errors.

When adding a test framework in the future, wire it to `npm test` and document the command here and in `README.md`.

## Preferred Development Workflow for Codex

1. **Read project context first.** Start with this file, then inspect `README.md`, `package.json`, and the specific source files relevant to the task.
2. **Check repository state.** Run `git status --short` before editing and avoid overwriting user changes.
3. **Make focused changes.** Keep patches small, coherent, and aligned with the existing CLI/module structure.
4. **Update documentation with behavior changes.** If commands, environment variables, permissions, or modes change, update `README.md` and this file when appropriate.
5. **Validate locally.** Prefer syntax checks and non-network checks first; run API-backed commands only when credentials and network access are available.
6. **Review the diff.** Use `git diff` and confirm no secrets or unintended files are included.
7. **Commit changes.** Use a concise imperative commit message that describes the user-visible change.
8. **Prepare a PR summary.** Include what changed and what validation was run.

## Git and Commit Conventions

- Keep commits focused on one logical change.
- Use imperative commit subjects, for example:
  - `Add repository agent guide`
  - `Refine chat access error handling`
  - `Document CLI environment variables`
- Do not commit generated dependency folders such as `node_modules/`.
- Do not commit `.env` files or local machine artifacts.

## Security and Secret Handling

- Treat API keys and tokens as secrets even in examples.
- Never add real secrets to source files, docs, tests, fixtures, PR descriptions, or commit messages.
- Before committing, scan documentation changes for accidental credentials.
- Prefer environment variables for all sensitive configuration.
- If a secret is discovered in repository history or documentation, flag it immediately and recommend rotation; do not copy it into new files.

## Documentation Conventions

- Keep `README.md` user-focused: installation, environment variables, commands, and examples.
- Keep `AGENTS.md` agent-focused: architecture, conventions, workflow, and repository-specific instructions.
- Use fenced code blocks for commands and repository trees.
- Keep command examples copy-pasteable.
- Update docs in the same change as behavior changes.

## Dependency Conventions

- Add runtime dependencies only when they directly support project behavior.
- Add development dependencies only with a clear validation or maintenance purpose.
- After dependency changes, commit the lockfile if one exists or if npm generates one as part of the accepted workflow.
- Do not vendor third-party package contents into the repository.

## Future Improvement Goals

These are recommended directions, not requirements for every task:

- Add a real test suite and an `npm test` script.
- Add linting/formatting scripts for consistent JavaScript style.
- Replace deprecated or unavailable model examples with currently supported OpenAI APIs when modernizing the project.
- Move shared OpenAI client construction into a small helper if more modes are added.
- Improve CLI ergonomics with structured argument parsing if the command surface grows.
- Expand access-control tests once a test framework exists.
- Remove any real credentials from documentation and replace them with placeholders.

## Quick Command Reference

```bash
# Show repository status
git status --short

# Install dependencies
npm install

# Run the chat example
OPENAI_API_KEY=<your-api-key> npm run chat -- "Explain recursion"

# Run the codex example
OPENAI_API_KEY=<your-api-key> npm run codex -- "Generate a JavaScript function to sort an array"

# Override the default chat or code-generation model
OPENAI_CHAT_MODEL=gpt-4.1-mini npm run chat -- "Explain recursion"
OPENAI_CODE_MODEL=gpt-4.1-mini npm run codex -- "Generate a JavaScript function to sort an array"

# Enable local all-access mode for examples
ALL_ACCESS=true OPENAI_API_KEY=<your-api-key> npm run chat -- "Explain recursion"

# Syntax-check JavaScript without calling external APIs
node --check src/index.js
node --check src/access.js
node --check src/chat.js
node --check src/codex.js

# Check for whitespace errors before committing
git diff --check
```
