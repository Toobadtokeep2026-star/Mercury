import OpenAI from "openai";
import { ensurePermission, currentUser } from "./access.js";

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

  const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  const completion = await client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      {
        role: "system",
        content: "You are a helpful assistant that explains things clearly and concisely."
      },
      {
        role: "user",
        content: prompt
      }
    ],
    temperature: 0.7,
    max_tokens: 500
  });

  const message = completion.choices?.[0]?.message?.content ?? "(no response)";
  console.log("Response:");
  console.log(message.trim());
}
