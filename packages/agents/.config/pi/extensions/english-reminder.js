import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

export default function (pi) {
  pi.on("before_agent_start", (event) => {
    if (event.messageType === "custom") return;
    const configHome = process.env.XDG_CONFIG_HOME || join(homedir(), ".config");
    return {
      message: {
        customType: "english-reminder",
        content: readFileSync(join(configHome, "agents/english-reminder.txt"), "utf8").trim(),
        display: false,
      },
    };
  });
}
