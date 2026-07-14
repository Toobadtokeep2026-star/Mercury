import { runOpenAIExample } from "./exampleRunner.js";

export async function runChatExample(prompt) {
  return runOpenAIExample({
    prompt,
    title: "ChatGPT",
    permission: "chat.run",
    deniedMessage: "ERROR: access denied. Set ALL_ACCESS=true or change USER_ROLE to allow chat.run.",
    outputLabel: "Response",
    createCompletion: (client, userPrompt) => client.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        {
          role: "system",
          content: "You are a helpful assistant that explains things clearly and concisely."
        },
        {
          role: "user",
          content: userPrompt
        }
      ],
      temperature: 0.7,
      max_tokens: 500
    }),
    getOutput: (completion) => completion.choices?.[0]?.message?.content
  });
}
