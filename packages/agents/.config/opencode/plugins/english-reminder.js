import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

// OpenCode 1.x plugin API. Revisit when upgrading to OpenCode 2.
export default async function () {
  return {
    "experimental.chat.system.transform": async (input, output) => {
      if (!input.sessionID) return;
      const configHome = process.env.XDG_CONFIG_HOME || join(homedir(), ".config");
      output.system.push(
        readFileSync(join(configHome, "agents/english-reminder.txt"), "utf8").trim(),
      );
    },
  };
}
