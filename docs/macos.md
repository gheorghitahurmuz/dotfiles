# macOS

Reapply preferences:

```sh
bash scripts/macos.sh
```

- Screenshots go to `~/Pictures`; desktop icons and widgets are hidden.
- Dock apps are replaced only when their ordered paths differ.
- Trash items are removed after 30 days.
- Caps Lock → Control lasts for the current session. Make it persistent in
  System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys.
- The script requests sudo in an interactive terminal immediately before applying
  preferences. Without authorization, required administrative changes remain incomplete.
- Timezone is verified through `/etc/localtime`: `systemsetup` can print
  `Error:-99` even after applying the requested zone. Startup volume and keyboard
  mappings are also read back; existing keyboard mappings are preserved.
- Saved preference values are read back; this does not verify their visual effect.
  Unchanged preferences are skipped; only affected processes are restarted.
  Some settings need a logout and login.
- Wallpaper uses System Events and needs an available desktop session and
  Automation permission. A failure leaves configuration incomplete but allows
  the remaining preferences to run. Log into the desktop and rerun the script.
