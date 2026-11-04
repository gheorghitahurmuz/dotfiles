# Tart

Use a stopped baseline with an admin account, Remote Login enabled, and no
Homebrew or dotfiles. Finish Setup Assistant and log into the desktop first.

```sh
brew install openai/tools/tart jq
bash scripts/test-vm.sh
```

The script downloads `macos-clean` if missing, then clones it for testing.
Pass a different baseline name as an optional argument. It copies current files
without private overrides and runs `install.sh` once. Set `VM_USER` if the guest
user is not `admin`.
Before copying files, it rejects running baselines, existing Homebrew or dotfiles,
shared host folders, and guests without the requested user logged into the desktop.
These checks establish bootstrap prerequisites, not a factory-reset system.
The checks run under Bash with a system PATH. One SSH connection is reused for
checks, transfer, and installation; enter the SSH password once, then sudo when
requested. The VM command explicitly exports `HOMEBREW_BUNDLE_MAS_SKIP` with
the shared Brewfile's App Store IDs before running the installer. The installer
also detects VMs and skips App Store apps; their installation remains unverified.

The VM stays open. To check a second installation, run inside its Terminal:

```sh
cd ~/Developer/dotfiles
bash install.sh
```

If SSH reports `No route to host`, check the terminal app under System Settings →
Privacy & Security → Local Network. A successful port probe does not guarantee
that SSH has network access.

Delete stopped local VMs except `macos-clean`, then clear OCI and IPSW caches:

```sh
tart list --source local --format json |
  jq -r '.[] | select(.State == "stopped" and .Name != "macos-clean") | .Name' |
  while IFS= read -r vm; do tart delete "$vm"; done
tart prune --entries caches --space-budget 0
```

Running VMs and `macos-clean` are kept.

## Sources

- [Tart quick start](https://tart.run/quick-start/): installation, image creation,
  SSH access, and baseline preparation. Verify what a prebuilt image includes.

- [Apple: Local Network access](https://support.apple.com/en-gb/guide/mac-help/mchla4f49138/mac):
  allow the terminal app to reach local devices, including VMs.

- [Homebrew manual](https://docs.brew.sh/Manpage#bundle-subcommand):
  `HOMEBREW_BUNDLE_MAS_SKIP` excludes App Store entries by ID for a test run.
