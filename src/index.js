import { runChatExample } from "./chat.js";
import { runCodexExample } from "./codex.js";

const [,, mode = "help", ...promptParts] = process.argv;
const prompt = promptParts.join(" ").trim();

const usage = () => {
  console.log("Mercury OpenAI reference project");
  console.log("");
  console.log("Usage:");
  console.log("  npm run chat -- <prompt>");
  console.log("  npm run codex -- <prompt>");
  console.log("");
  console.log("Examples:");
  console.log("  npm run chat -- 'Explain recursion in simple terms'");
  console.log("  npm run codex -- 'Generate a JavaScript function to sort an array'");
};

if (!process.env.OPENAI_API_KEY) {
  console.error("ERROR: OPENAI_API_KEY is not set.");
  process.exit(1);
}

if (!prompt) {
  usage();
  process.exit(0);
}

switch (mode.toLowerCase()) {
  case "chat":
    await runChatExample(prompt);
    break;
  case "codex":
    await runCodexExample(prompt);
    break;
  default:
    usage();
    break;
}
