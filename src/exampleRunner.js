import { currentUser, ensurePermission } from "./access.js";
import { getOpenAIClient } from "./openaiClient.js";

export async function runOpenAIExample({
  prompt,
  title,
  permission,
  deniedMessage,
  createCompletion,
  outputLabel,
  getOutput
}) {
  console.log(`Running ${title} reference example...`);
  console.log(`Prompt: ${prompt}\n`);

  try {
    ensurePermission(permission, currentUser());
  } catch (err) {
    if (err.code === "E_PERMISSION") {
      console.error(deniedMessage);
      return;
    }
    throw err;
  }

  const completion = await createCompletion(getOpenAIClient(), prompt);
  const output = getOutput(completion) ?? "(no response)";

  console.log(`${outputLabel}:`);
  console.log(output.trim());
}
