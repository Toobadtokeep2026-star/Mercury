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

## Access / Permissions

This project includes a small access utility used by the CLI examples to gate functionality.

- Enable all-access mode for local development:

```bash
export ALL_ACCESS=true
export OPENAI_API_KEY=<your-api-key>
npm run chat -- "Explain recursion"
```

- Alternatively set a role via `USER_ROLE` (default: `user`). Roles and permissions can be overridden with `ROLES_JSON` (JSON map).

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
