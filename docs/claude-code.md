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

English correction: a `UserPromptSubmit` hook reminds Claude on every prompt.
Add it under `hooks` in `settings.json`:

```json
"UserPromptSubmit": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "echo '[REMINDER: correct English mistakes at end of response per CLAUDE.md rules]'"
      }
    ]
  }
]
```

The hook only points to the rules; put them in `~/.config/claude/CLAUDE.md`:

```markdown
## English Correction Rules

The user is a Romanian speaker learning English.
At the end of every reply to the user (not in subagent reports, commits, PRs or tickets), add an "**English**" section.
If the user made mistakes, format corrections as:

- ❌ original → ✅ correction _(reason)_

If no mistakes, write: "✅ No English issues found in this message."
Keep it brief — max 3 corrections per message.
Ignore capitalization (lowercase vs uppercase) and punctuation (periods, question marks, commas); don't report them as mistakes.
```

- Needs `jq` (in the Brewfile).
- Validate after editing: `jq empty ~/.config/claude/settings.json`. Invalid
  JSON, such as a trailing comma, makes Claude Code ignore the whole file.
