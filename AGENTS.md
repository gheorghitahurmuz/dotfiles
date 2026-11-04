# Agent instructions

Read [docs/architecture.md](docs/architecture.md) and the relevant tool notes in
`docs/` before changing configuration.

## Design and scope

- `packages/` holds one Stow package per directory, configuration only. `scripts/`
  handles operations and checks; `install.sh` coordinates them; `docs/` holds notes.
- Edit managed files in the repository. Packages use literal dot paths; `.stowrc`
  sets the package directory and home target, with directory folding disabled.
- Keep changes focused, workflows explicit in `main`, and functions small. Prefer
  local variables and explicit inputs. Add abstractions or automation for a concrete need.
- Declare shared software in the Brewfile; keep private and machine-specific
  additions unversioned. Keep upgrades separate: `--no-upgrade` still allows
  required dependency updates and does not pin versions.
- Preserve idempotency and Doctor's conflict checks. Never automatically overwrite
  or adopt conflicting home files. Run installation, preferences, software removal,
  or home-link changes only when the task calls for those operations.

## Writing

- Use concise, direct English. README covers installation only. Tool notes contain
  useful reminders and caveats, not tutorials, inventories, research logs, or history.
- Keep architecture abstract: principles and responsibilities, without commands,
  application examples, layouts, or implementation plans. Omit references to
  previous configuration managers.
- Preserve user-provided sources and article links in `docs/`, with brief takeaways.
  Remove them only when explicitly asked.

## Shell and migration safety

- Support macOS's bundled Bash. With `set -u`, guard empty-array expansions and
  exercise empty collections using `/bin/bash`.
- Explicitly propagate required failures inside command substitutions; `set -e`
  does not reliably stop functions invoked through `$(...)`. Validate their output.
- Keep Doctor and installation consistent: simulate all packages together and use
  both `--no-folding` and `--restow` to unfold existing Stow directory links.
- Resolve paths before claiming local data stays outside the repository: a parent
  may be a symlink. Migration must handle partial and interrupted layouts.
- Check conflicts before moving data. Preserve tracked and conflicting files;
  replace only links verified to reference the exact source being moved.
- Avoid `path` as a Zsh variable: it changes `PATH`.
- `BASH_SOURCE` is empty under `bash -c` and pipes, as in the README installer
  command. Guard it with `set -u` and exercise that entry point too.

## Verification

Match checks to the changed behavior and update affected notes. Use temporary
scripts and isolated environments outside the repository; do not add `tests/`.

- Run `bash -n` or `zsh -n` for changed shell files, `shellcheck` for Bash
  scripts, and relevant configuration syntax checks when available. Report checks
  that could not run.
- For installation or migration changes, test fresh and previous layouts. Run the
  operation twice; inspect files, links, preserved data, and unnecessary writes or
  restarts. State what was compared: two successful exits do not prove idempotency.
- Exercise relevant failures: failed downloads or clones, incomplete repositories,
  existing local files, and tracked files that must not move.
- Report skipped required configuration as incomplete. Distinguish simulation
  from real-system verification, and sandbox limits from host failures.

### macOS preferences

- Compare semantic state: normalize numeric values and compare ordered Dock app
  paths rather than OS-maintained metadata. Read back administrative changes.
- `systemsetup` may print `Error:-99` after setting the timezone successfully;
  verify `/etc/localtime` before reporting failure.
- Parse `hidutil` output as a plist, normalize numeric strings, and preserve
  unrelated mappings. Stop on conflicting Caps Lock mappings.
- GUI failures must mark configuration incomplete while allowing independent
  preferences to continue. System Events can time out over SSH.
- If guest readback differs from mocks, capture raw guest values before changing
  comparisons. Host output and simulated writes do not establish guest state.

### VM installation

- Test the current checkout, including uncommitted changes, through the documented
  installer entry point. Prepare transfer first; do not preinstall dependencies
  the installer should bootstrap.
- Preserve the base VM and inspect the guest's starting state. Use a fresh copy if
  the baseline changed; do not call an unverified baseline clean.
- Remove inherited host sharing from the test copy. Transfer only needed files,
  excluding private overrides, and copy onto guest storage before installation.
  Stow links must not depend on host mounts; keep shared test files read-only
  where possible.
- Select the remote shell explicitly and fail on inspection errors. Test the SSH
  wrapper with the guest login shell. A TCP probe does not prove SSH connectivity;
  diagnose with the actual binary and distinguish startup errors from permissions.
- Keep the VM command's explicit `HOMEBREW_BUNDLE_MAS_SKIP` export before
  `bash install.sh`. Use App Store IDs, not a boolean. The installer also skips MAS
  when `kern.hv_vmm_present` is `1`; preserve normal installation on physical Macs
  and report VM App Store installation as unverified.
- Preserve installer exit status through logging pipelines and keep VM artifacts
  after failure.

## Maintaining these instructions

Review this file before the final response after implementation and verification.
Fold durable lessons from observed failures or user corrections into the relevant
rule; merge duplicates and remove obsolete guidance. Do not add run logs or
speculative rules. Leave it unchanged when no durable lesson emerges, and mention
substantive updates in the final response.
