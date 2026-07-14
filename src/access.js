const DEFAULT_ROLE = "user";
const ALL_ACCESS = String(process.env.ALL_ACCESS || "").toLowerCase() === "true";
const WILDCARD_PERMISSION = "*";

const DEFAULT_ROLES = {
  admin: [WILDCARD_PERMISSION],
  user: ["chat.run", "codex.run"],
  guest: []
};

function roleFromEnvironment() {
  return process.env.USER_ROLE || DEFAULT_ROLE;
}

function getRoles() {
  if (!process.env.ROLES_JSON) return DEFAULT_ROLES;

  try {
    return JSON.parse(process.env.ROLES_JSON);
  } catch {
    // Ignore parse errors and fall back to defaults.
    return DEFAULT_ROLES;
  }
}

function permissionsForRole(role) {
  return getRoles()[role] || [];
}

function hasPermission(role, permission) {
  if (ALL_ACCESS) return true;

  const permissions = permissionsForRole(role);
  return permissions.includes(WILDCARD_PERMISSION) || permissions.includes(permission);
}

export function can(permission, user = currentUser()) {
  return hasPermission(user.role, permission);
}

export function ensurePermission(permission, user = currentUser()) {
  if (!hasPermission(user.role, permission)) {
    const err = new Error(`Permission denied: ${permission}`);
    err.code = "E_PERMISSION";
    throw err;
  }
}

export function currentUser() {
  return { role: roleFromEnvironment() };
}

export default { can, ensurePermission, currentUser };
