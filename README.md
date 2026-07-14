# Mercury
Initial ChatGPT mercury project

## Access / Permissions

This project includes a small access utility used by the CLI examples to gate functionality.

- Enable all-access mode (useful for local development):

```bash
export ALL_ACCESS=true
export OPENAI_API_KEY=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
npm run chat -- "Explain recursion"
```

- Alternatively set a role via `USER_ROLE` (default: `user`). Roles and permissions can be overridden with `ROLES_JSON` (JSON map).

