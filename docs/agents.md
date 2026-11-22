# Shared agent instructions

`packages/agents` provides one personal rules file at
`~/.config/agents/AGENTS.md`. The global instruction files for Claude Code,
Codex, OpenCode, and Pi link to it. Edit the shared file in the repository.
Existing instruction files must be merged before Stow can replace them.

The English correction reminder is also shared:
`~/.config/agents/english-reminder.txt`.

For Claude Code, replace the existing English reminder command under
`hooks.UserPromptSubmit` in `~/.config/claude/settings.json` with:

```json
{
  "type": "command",
  "command": "cat \"${XDG_CONFIG_HOME:-$HOME/.config}/agents/english-reminder.txt\""
}
```

For Codex, add the same command hook under `hooks.UserPromptSubmit` in
`~/.config/codex/hooks.json`, using the enclosing structure below. Merge with
existing hooks; preserve other events and commands.

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "cat \"${XDG_CONFIG_HOME:-$HOME/.config}/agents/english-reminder.txt\""
          }
        ]
      }
    ]
  }
}
```

Codex also needs `hooks = true` under `[features]` in `config.toml`.
Validate both JSON files with `jq empty` after editing. Restart the harnesses;
Codex may require trusting the new hook through its hook review flow.

Pi's extension injects the reminder before each user-started run. OpenCode's
1.x plugin adds it before session model requests, including tool continuations.
These adapters read the same reminder file. They do not enforce compliance.
OpenCode 2 uses a different plugin API; review the adapter before upgrading.

The package uses the paths set by this repository's `.zshenv` and the default
OpenCode config directory. Custom config locations need matching links.
Keep writable application settings and session data outside this package.

References: [Codex hooks](https://learn.chatgpt.com/docs/hooks),
[Pi extensions](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/extensions.md),
[OpenCode 1.19.6 hook API](https://github.com/anomalyco/opencode/blob/v1.19.6/packages/plugin/src/index.ts).
