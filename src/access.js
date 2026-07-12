const DEFAULT_ROLE = process.env.USER_ROLE || "user";
const ALL_ACCESS = String(process.env.ALL_ACCESS || "").toLowerCase() === "true";

const DEFAULT_ROLES = {
  admin: ["*"],
  user: ["chat.run", "codex.run"],
  guest: []
};

function getRoles() {
  try {
    if (process.env.ROLES_JSON) return JSON.parse(process.env.ROLES_JSON);
  } catch (e) {
    // ignore parse errors and fall back to defaults
  }
  return DEFAULT_ROLES;
}

function hasPermission(role, permission) {
  if (ALL_ACCESS) return true;
  const roles = getRoles();
  const perms = roles[role] || [];
  if (perms.includes("*")) return true;
  return perms.includes(permission);
}

export function can(permission, user = { role: DEFAULT_ROLE }) {
  return hasPermission(user.role, permission);
}

export function ensurePermission(permission, user = { role: DEFAULT_ROLE }) {
  if (!hasPermission(user.role, permission)) {
    const err = new Error(`Permission denied: ${permission}`);
    err.code = "E_PERMISSION";
    throw err;
  }
}

export function currentUser() {
  return { role: process.env.USER_ROLE || DEFAULT_ROLE };
}

export default { can, ensurePermission, currentUser };
