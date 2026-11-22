# Claude Code

Configuration: `~/.config/claude` (`CLAUDE_CONFIG_DIR` in `.zshenv`).

`settings.json` is not managed because Claude Code rewrites it. Add the status
line on each machine (model | 5-hour | 7-day usage):

```json
"statusLine": {
  "type": "command",
  "command": "jq -r '(.rate_limits.five_hour // {}) as $f | (.rate_limits.seven_day // {}) as $w | [\"\\u001b[33m\" + (.model.display_name // \"?\") + \"\\u001b[0m\", (if $f.used_percentage != null then \"5h: \" + ($f.used_percentage | round | tostring) + \"%\" else empty end), (if $w.used_percentage != null then \"7d: \" + ($w.used_percentage | round | tostring) + \"%\" else empty end)] | join(\" | \")'"
}
```

English correction rules live once in `~/.config/agents/AGENTS.md`;
`~/.config/claude/CLAUDE.md` links to that file. The rules apply to user-facing
replies, excluding subagent reports and generated artifacts.

A `UserPromptSubmit` hook reinforces the rules on each prompt. Merge this into
`settings.json`, replacing the old English reminder while preserving other
hooks:

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
Restart Claude Code after editing. The reminder improves consistency but
cannot guarantee that the model follows the rules.

See [shared agent configuration](agents.md) for the Stow links and the other
harness adapters.

- Needs `jq` (in the Brewfile).
- Validate after editing: `jq empty ~/.config/claude/settings.json`. Invalid
  JSON, such as a trailing comma, makes Claude Code ignore the whole file.
