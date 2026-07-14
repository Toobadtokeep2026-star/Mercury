import { runOpenAIExample } from "./exampleRunner.js";

export async function runCodexExample(prompt) {
  return runOpenAIExample({
    prompt,
    title: "Codex",
    permission: "codex.run",
    deniedMessage: "ERROR: access denied. Set ALL_ACCESS=true or change USER_ROLE to allow codex.run.",
    outputLabel: "Generated code",
    createCompletion: (client, userPrompt) => client.completions.create({
      model: "code-davinci-002",
      prompt: userPrompt,
      max_tokens: 240,
      temperature: 0.2,
      stop: ["\n\n"]
    }),
    getOutput: (completion) => completion.choices?.[0]?.text
  });
}
