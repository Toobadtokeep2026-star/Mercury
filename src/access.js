const ALL_ACCESS_VALUE = "true";

const DEFAULT_ROLES = {
  admin: ["*"],
  user: ["chat.run", "codex.run"],
  guest: []
};

let cachedRolesJson;
let cachedRoles;

function allAccessEnabled() {
  return String(process.env.ALL_ACCESS || "").toLowerCase() === ALL_ACCESS_VALUE;
}

function defaultRole() {
  return process.env.USER_ROLE || "user";
}

function getRoles() {
  if (!process.env.ROLES_JSON) return DEFAULT_ROLES;
  if (process.env.ROLES_JSON === cachedRolesJson) return cachedRoles;

  cachedRolesJson = process.env.ROLES_JSON;
  try {
    cachedRoles = JSON.parse(process.env.ROLES_JSON);
  } catch (e) {
    // ignore parse errors and fall back to defaults
    cachedRoles = DEFAULT_ROLES;
  }
  return cachedRoles;
}

function hasPermission(role, permission) {
  if (allAccessEnabled()) return true;

  const perms = getRoles()[role] || [];
  return perms.includes("*") || perms.includes(permission);
}

export function can(permission, user = { role: defaultRole() }) {
  return hasPermission(user.role, permission);
}

export function ensurePermission(permission, user = { role: defaultRole() }) {
  if (!hasPermission(user.role, permission)) {
    const err = new Error(`Permission denied: ${permission}`);
    err.code = "E_PERMISSION";
    throw err;
  }
}

export function currentUser() {
  return { role: defaultRole() };
}

export default { can, ensurePermission, currentUser };
