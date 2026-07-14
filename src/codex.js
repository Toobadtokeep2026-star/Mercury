import OpenAI from "openai";
import { ensurePermission, currentUser } from "./access.js";

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const CODE_MODEL = process.env.OPENAI_CODE_MODEL || "gpt-4.1-mini";

export async function runCodexExample(prompt) {
  console.log("Running code-generation reference example...");
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

  const response = await client.responses.create({
    model: CODE_MODEL,
    instructions: [
      "You are a concise code-generation assistant.",
      "Return only the requested code unless a brief explanation is necessary."
    ].join(" "),
    input: prompt,
    temperature: 0.2,
    max_output_tokens: 500
  });

  const text = response.output_text ?? "(no response)";
  console.log("Generated code:");
  console.log(text.trim());
}
