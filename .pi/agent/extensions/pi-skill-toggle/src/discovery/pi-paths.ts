import { homedir } from "node:os";
import { realpathSync } from "node:fs";
import { join, resolve } from "node:path";
import type { SkillSource } from "../types.ts";

export interface SkillRoot {
  path: string;
  source: SkillSource;
  includeRootMarkdownFiles: boolean;
}

export function getAgentDir(): string {
  const configured = process.env.PI_CODING_AGENT_DIR?.trim();
  if (configured) return expandHome(configured);
  return join(homedir(), ".pi", "agent");
}

export function getGlobalAgentsSkillDir(): string {
  return join(homedir(), ".agents", "skills");
}

export function getSkillRoots(cwd: string): SkillRoot[] {
  const resolvedCwd = resolve(cwd);
  const userSkillRoot = join(getAgentDir(), "skills");
  const globalSkillRoot = getGlobalAgentsSkillDir();
  const projectSkillRoot = resolve(resolvedCwd, ".pi", "skills");
  const projectLegacySkillRoot = resolve(resolvedCwd, ".agents", "skills");
  const roots: SkillRoot[] = [
    {
      path: userSkillRoot,
      source: { kind: "user", root: userSkillRoot },
      includeRootMarkdownFiles: true,
    },
    {
      path: globalSkillRoot,
      source: { kind: "global", root: globalSkillRoot },
      includeRootMarkdownFiles: false,
    },
    {
      path: projectSkillRoot,
      source: { kind: "project", root: projectSkillRoot },
      includeRootMarkdownFiles: true,
    },
    // Pi also loads .agents/skills as a project skill directory. Root markdown
    // files are ignored there; directories containing SKILL.md are discovered.
    {
      path: projectLegacySkillRoot,
      source: { kind: "project-legacy", root: projectLegacySkillRoot },
      includeRootMarkdownFiles: false,
    },
  ];

  const seen = new Set<string>();
  return roots.filter((root) => {
    // Dedupe by canonical path so a symlinked root (e.g. ~/.agents -> dotfiles)
    // and the real directory behind it are not scanned twice.
    const key = canonicalPath(root.path);
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}

function canonicalPath(path: string): string {
  try {
    return realpathSync(resolve(path));
  } catch {
    return resolve(path);
  }
}

function expandHome(input: string): string {
  if (input === "~") return homedir();
  if (input.startsWith("~/")) return join(homedir(), input.slice(2));
  return input;
}
