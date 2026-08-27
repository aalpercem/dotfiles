import { Plugin } from "@opencode-ai/plugin";
import { SystemPart } from "@opencode-ai/ai";
import { createRequire } from "module";
import fs from "fs";
import os from "os";
import path from "path";

const require = createRequire(import.meta.url);
const hooksDir = path.join(os.homedir(), ".local/share/ponytail/hooks");
const { getPonytailInstructions } = require(path.join(hooksDir, "ponytail-instructions.js"));
const { getDefaultMode, normalizePersistedMode } = require(path.join(hooksDir, "ponytail-config.js"));

const statePath = path.join(
  process.env.XDG_CONFIG_HOME || path.join(os.homedir(), ".config"),
  "opencode",
  ".ponytail-active",
);

function readMode(): string {
  try {
    return normalizePersistedMode(fs.readFileSync(statePath, "utf8").trim()) || getDefaultMode();
  } catch {
    return getDefaultMode();
  }
}

function writeMode(mode: string) {
  fs.mkdirSync(path.dirname(statePath), { recursive: true });
  fs.writeFileSync(statePath, mode);
}

function textOf(msg: any): string {
  const parts = msg?.content;
  if (!Array.isArray(parts)) return "";
  return parts
    .filter((p: any) => p?.type === "text" && typeof p.text === "string")
    .map((p: any) => p.text)
    .join("");
}

export default Plugin.define({
  id: "ponytail",
  setup: async (ctx) => {
    await ctx.session.hook("context", (event) => {
      const msgs = event.messages || [];
      const last = msgs[msgs.length - 1];
      let lastText = last?.role === "user" ? textOf(last) : "";
      lastText = lastText.trim().replace(/^"+|"+$/g, "");

      const m = lastText.match(/^\/ponytail\s*(\S*)/);
      if (m) {
        const mode = (m[1] || "full").toLowerCase();
        writeMode(mode);
      }

      const mode = readMode();
      if (mode !== "off") {
        // ponytail: context hook doc says this mutates the model request.
        // In beta-17288 the push is accepted but model-visible propagation
        // is unconfirmed with the free provider. Flag file works correctly.
        event.system = [...event.system, SystemPart.make(getPonytailInstructions(mode))];
      }
    });
  },
});