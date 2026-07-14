const DEFAULT_ROLES = {
  admin: ["*"],
  user: ["chat.run", "codex.run"],
  guest: []
};

function defaultRole() {
  return process.env.USER_ROLE || "user";
}

function allAccessEnabled() {
  return String(process.env.ALL_ACCESS || "").toLowerCase() === "true";
}

function getRoles() {
  try {
    if (process.env.ROLES_JSON) return JSON.parse(process.env.ROLES_JSON);
  } catch (e) {
    // ignore parse errors and fall back to defaults
  }
  return DEFAULT_ROLES;
}

function hasPermission(role, permission) {
  if (allAccessEnabled()) return true;
  const roles = getRoles();
  const perms = roles[role] || [];
  if (perms.includes("*")) return true;
  return perms.includes(permission);
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
