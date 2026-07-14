const [,, mode = "help", ...promptParts] = process.argv;
const normalizedMode = mode.toLowerCase();
const prompt = promptParts.join(" ").trim();

const runners = {
  chat: () => import("./chat.js").then(({ runChatExample }) => runChatExample),
  codex: () => import("./codex.js").then(({ runCodexExample }) => runCodexExample)
};

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

if (!prompt || !runners[normalizedMode]) {
  usage();
  process.exit(0);
}

if (!process.env.OPENAI_API_KEY) {
  console.error("ERROR: OPENAI_API_KEY is not set.");
  process.exit(1);
}

const run = await runners[normalizedMode]();
await run(prompt);
