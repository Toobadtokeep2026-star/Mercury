import test from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";

function runCli(args, env = {}) {
  return spawnSync(process.execPath, ["src/index.js", ...args], {
    cwd: process.cwd(),
    env: { ...process.env, ...env },
    encoding: "utf8"
  });
}

test("CLI fails fast when OPENAI_API_KEY is missing", () => {
  const env = { ...process.env };
  delete env.OPENAI_API_KEY;

  const result = spawnSync(process.execPath, ["src/index.js", "chat", "hello"], {
    cwd: process.cwd(),
    env,
    encoding: "utf8"
  });

  assert.equal(result.status, 1);
  assert.match(result.stderr, /ERROR: OPENAI_API_KEY is not set\./);
});

test("CLI prints usage when no prompt is supplied", () => {
  const result = runCli(["chat"], { OPENAI_API_KEY: "test-key" });

  assert.equal(result.status, 0);
  assert.match(result.stdout, /Mercury OpenAI reference project/);
  assert.match(result.stdout, /npm run chat -- <prompt>/);
});

test("CLI handles unknown modes without making a network request", () => {
  const result = runCli(["unknown", "hello"], { OPENAI_API_KEY: "test-key" });

  assert.equal(result.status, 0);
  assert.match(result.stdout, /Usage:/);
});

test("CLI denies guest chat access without making a network request", () => {
  const result = runCli(["chat", "hello"], { OPENAI_API_KEY: "test-key", USER_ROLE: "guest" });

  assert.equal(result.status, 0);
  assert.match(result.stdout, /Running ChatGPT reference example/);
  assert.match(result.stderr, /ERROR: access denied/);
});
