# Codex

Configuration: `~/.config/codex` (`CODEX_HOME` in `.zshenv`).

`config.toml` is not managed because it mixes preferences with machine-specific
paths, project trust, plugin settings, and application state. Configure the
status line on each machine with `/statusline`, or merge this into the existing
`[tui]` section in `config.toml`:

```toml
[tui]
status_line = ["model-with-reasoning", "context-remaining", "five-hour-limit", "weekly-limit"]
status_line_use_colors = true
```

The percentages show remaining context and allowances. Unavailable limits are
omitted.

English correction rules live once in `~/.config/agents/AGENTS.md`;
`~/.config/codex/AGENTS.md` links to that file. The rules apply to user-facing
replies, excluding subagent reports and generated artifacts.

A `UserPromptSubmit` hook reinforces the rules on each prompt. Merge this into
`~/.config/codex/hooks.json`, preserving existing hooks:

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

The command prints the shared reminder from
`~/.config/agents/english-reminder.txt`; it does not duplicate the rules.
Enable hooks by merging this into `config.toml`:

```toml
[features]
hooks = true
```

Validate with `jq empty ~/.config/codex/hooks.json`, then restart Codex. Review
and trust the new hook if Codex prompts for it. The reminder improves
consistency but cannot guarantee that the model follows the rules.

See [shared agent configuration](agents.md) for the Stow links and Pi/OpenCode
adapters. Restore other custom hooks and skills separately, reviewing
machine-specific paths.

Local command approvals live in `~/.config/codex/rules/default.rules`. Restart
Codex after editing the file. A `rex session rename` prefix rule matches when
Codex passes the session ID literally. Read `REX_SESSION` in a separate command
before invoking the rename, since variable expansion makes Codex match the full
shell command instead.

Keep authentication, conversations, databases, caches, downloaded plugins, and
project trust state out of Git.
