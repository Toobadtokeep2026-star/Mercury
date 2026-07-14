import test from "node:test";
import assert from "node:assert/strict";
import { runChatExample } from "../src/chat.js";
import { runCodexExample } from "../src/codex.js";

async function captureConsole(fn) {
  const originalLog = console.log;
  const originalError = console.error;
  const logs = [];
  const errors = [];
  console.log = (...args) => logs.push(args.join(" "));
  console.error = (...args) => errors.push(args.join(" "));

  try {
    await fn();
  } finally {
    console.log = originalLog;
    console.error = originalError;
  }

  return { logs, errors };
}

async function withEnv(env, fn) {
  const original = {
    ALL_ACCESS: process.env.ALL_ACCESS,
    USER_ROLE: process.env.USER_ROLE,
    ROLES_JSON: process.env.ROLES_JSON,
    OPENAI_API_KEY: process.env.OPENAI_API_KEY
  };

  for (const key of Object.keys(original)) delete process.env[key];
  Object.assign(process.env, env);

  try {
    return await fn();
  } finally {
    for (const key of Object.keys(original)) {
      if (original[key] === undefined) delete process.env[key];
      else process.env[key] = original[key];
    }
  }
}

test("runChatExample sends the expected chat completion request and prints the response", async () => {
  await withEnv({ USER_ROLE: "user" }, async () => {
    const requests = [];
    const client = {
      chat: {
        completions: {
          create: async (request) => {
            requests.push(request);
            return { choices: [{ message: { content: "  Hello from the mock network  " } }] };
          }
        }
      }
    };

    const { logs, errors } = await captureConsole(() => runChatExample("Explain tests", { client }));

    assert.deepEqual(errors, []);
    assert.equal(requests.length, 1);
    assert.equal(requests[0].model, "gpt-4o-mini");
    assert.equal(requests[0].messages.at(-1).content, "Explain tests");
    assert.match(logs.join("\n"), /Response:\nHello from the mock network/);
  });
});

test("runChatExample denies access before making a network request", async () => {
  await withEnv({ USER_ROLE: "guest" }, async () => {
    let called = false;
    const client = {
      chat: {
        completions: {
          create: async () => {
            called = true;
          }
        }
      }
    };

    const { errors } = await captureConsole(() => runChatExample("Denied", { client }));

    assert.equal(called, false);
    assert.match(errors.join("\n"), /ERROR: access denied/);
  });
});

test("runCodexExample sends the expected completion request and prints generated code", async () => {
  await withEnv({ USER_ROLE: "user" }, async () => {
    const requests = [];
    const client = {
      completions: {
        create: async (request) => {
          requests.push(request);
          return { choices: [{ text: "  const ok = true;  " }] };
        }
      }
    };

    const { logs, errors } = await captureConsole(() => runCodexExample("Generate a constant", { client }));

    assert.deepEqual(errors, []);
    assert.equal(requests.length, 1);
    assert.equal(requests[0].model, "code-davinci-002");
    assert.equal(requests[0].prompt, "Generate a constant");
    assert.deepEqual(requests[0].stop, ["\n\n"]);
    assert.match(logs.join("\n"), /Generated code:\nconst ok = true;/);
  });
});

test("runCodexExample denies access before making a network request", async () => {
  await withEnv({ USER_ROLE: "guest" }, async () => {
    let called = false;
    const client = {
      completions: {
        create: async () => {
          called = true;
        }
      }
    };

    const { errors } = await captureConsole(() => runCodexExample("Denied", { client }));

    assert.equal(called, false);
    assert.match(errors.join("\n"), /ERROR: access denied/);
  });
});
