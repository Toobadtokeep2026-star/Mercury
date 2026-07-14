import { ensurePermission, currentUser } from "./access.js";

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

  const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  const completion = await client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      {
        role: "system",
        content: "You generate concise, readable code examples. Return only the requested code unless explanation is explicitly requested."
      },
      {
        role: "user",
        content: prompt
      }
    ],
    temperature: 0.2,
    max_tokens: 500
  });

  const text = completion.choices?.[0]?.message?.content ?? "(no response)";
  console.log("Generated code:");
  console.log(text.trim());
}
