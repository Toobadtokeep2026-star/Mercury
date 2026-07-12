import OpenAI from "openai";
import { ensurePermission, currentUser } from "./access.js";

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

export async function runCodexExample(prompt) {
  console.log("Running Codex reference example...");
  console.log(`Prompt: ${prompt}\n`);

  try {
    ensurePermission("codex.run", currentUser());
  } catch (err) {
    if (err.code === "E_PERMISSION") {
      console.error("ERROR: access denied. Set ALL_ACCESS=true or change USER_ROLE to allow codex.run.");
      return;
    }
    throw err;
  }

  const completion = await client.completions.create({
    model: "code-davinci-002",
    prompt,
    max_tokens: 240,
    temperature: 0.2,
    stop: ["\n\n"]
  });

  const text = completion.choices?.[0]?.text ?? "(no response)";
  console.log("Generated code:");
  console.log(text.trim());
}
