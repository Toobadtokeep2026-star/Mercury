# Mercury
Initial ChatGPT mercury project

## Access / Permissions

This project includes a small access utility used by the CLI examples to gate functionality.

- Enable all-access mode (useful for local development):

```bash
export ALL_ACCESS=true
export OPENAI_API_KEY=<your-api-key>
npm run chat -- "Explain recursion"
```

- Alternatively set a role via `USER_ROLE` (default: `user`). Roles and permissions can be overridden with `ROLES_JSON` (JSON map).
## Testing

Run the unit and integration tests with:

```bash
npm test
```

The test suite uses Node.js built-in test runner, mocks OpenAI client calls for mode runner coverage, and exercises CLI behavior without making external API requests.

