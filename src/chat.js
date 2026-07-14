import OpenAI from "openai";
import { ensurePermission, currentUser } from "./access.js";

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
const CHAT_MODEL = process.env.OPENAI_CHAT_MODEL || "gpt-4.1-mini";

export async function runChatExample(prompt) {
  console.log("Running ChatGPT reference example...");
  console.log(`Prompt: ${prompt}\n`);

  try {
    ensurePermission("chat.run", currentUser());
  } catch (err) {
    if (err.code === "E_PERMISSION") {
      console.error("ERROR: access denied. Set ALL_ACCESS=true or change USER_ROLE to allow chat.run.");
      return;
    }
    throw err;
  }

  const response = await client.responses.create({
    model: CHAT_MODEL,
    instructions: "You are a helpful assistant that explains things clearly and concisely.",
    input: prompt,
    temperature: 0.7,
    max_output_tokens: 500
  });

  const message = response.output_text ?? "(no response)";
  console.log("Response:");
  console.log(message.trim());
}
