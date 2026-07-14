import test from "node:test";
import assert from "node:assert/strict";
import { can, ensurePermission, currentUser } from "../src/access.js";

function withEnv(env, fn) {
  const original = {
    ALL_ACCESS: process.env.ALL_ACCESS,
    USER_ROLE: process.env.USER_ROLE,
    ROLES_JSON: process.env.ROLES_JSON
  };

  for (const key of Object.keys(original)) delete process.env[key];
  Object.assign(process.env, env);

  try {
    fn();
  } finally {
    for (const key of Object.keys(original)) {
      if (original[key] === undefined) delete process.env[key];
      else process.env[key] = original[key];
    }
  }
}

test("default user role can run chat and codex examples", () => {
  withEnv({}, () => {
    assert.equal(currentUser().role, "user");
    assert.equal(can("chat.run"), true);
    assert.equal(can("codex.run"), true);
    assert.equal(can("admin.run"), false);
  });
});

test("guest role is denied and ensurePermission throws E_PERMISSION", () => {
  withEnv({ USER_ROLE: "guest" }, () => {
    assert.equal(can("chat.run"), false);
    assert.throws(
      () => ensurePermission("chat.run"),
      (err) => err.code === "E_PERMISSION" && err.message === "Permission denied: chat.run"
    );
  });
});

test("ALL_ACCESS bypasses role permissions dynamically", () => {
  withEnv({ USER_ROLE: "guest", ALL_ACCESS: "true" }, () => {
    assert.equal(can("chat.run"), true);
    assert.doesNotThrow(() => ensurePermission("codex.run"));
  });
});

test("ROLES_JSON overrides default role permissions", () => {
  withEnv({ USER_ROLE: "analyst", ROLES_JSON: JSON.stringify({ analyst: ["chat.run"] }) }, () => {
    assert.equal(can("chat.run"), true);
    assert.equal(can("codex.run"), false);
  });
});

test("invalid ROLES_JSON falls back to defaults", () => {
  withEnv({ USER_ROLE: "user", ROLES_JSON: "not json" }, () => {
    assert.equal(can("chat.run"), true);
  });
});
