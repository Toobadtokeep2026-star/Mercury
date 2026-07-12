# Mercury
Initial ChatGPT mercury project

## Access / Permissions

This project includes a small access utility used by the CLI examples to gate functionality.

- Enable all-access mode (useful for local development):

```bash
export ALL_ACCESS=true
export OPENAI_API_KEY=your_key_here
npm run chat -- "Explain recursion"
```

- Alternatively set a role via `USER_ROLE` (default: `user`). Roles and permissions can be overridden with `ROLES_JSON` (JSON map).

