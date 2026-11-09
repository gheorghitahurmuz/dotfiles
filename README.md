# Install

Run on macOS:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/gheorghitahurmuz/dotfiles/HEAD/install.sh)"
```

Or clone and install locally:

```sh
mkdir -p ~/Developer
git clone https://github.com/gheorghitahurmuz/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
bash install.sh
```

To rerun installation from the repository:

```sh
bash install.sh
```

# How it works

The installer runs under `set -e`: the first failing step ends the run. Nothing
changes on the machine before Homebrew, and nothing changes in the home
directory before Stow.

```mermaid
flowchart TD
    subgraph read["Reads only"]
        A[require_macos] --> B[find_dotfiles_repo]
    end
    B -->|"existing dir, not a repo"| X1(["exit 1"])
    B --> C
    subgraph install["Installs software"]
        C[ensure_homebrew] --> D[load_homebrew]
        D --> E{"repo found?"}
        E -->|no| F[clone_dotfiles_repo]
        E -->|yes| G
        F --> G[ensure_stow]
        G --> H[scripts/doctor.sh]
        H --> I["brew bundle install --no-upgrade"]
    end
    H -->|"exit 1"| X2(["install stops"])
    subgraph home["Changes the home directory"]
        I --> J["stow --no-folding --restow packages/*"]
    end
    subgraph prefs["System preferences"]
        J --> K[scripts/macos.sh]
    end
    K -->|"exit 1"| X3(["install exits 1, links already applied"])
```

`find_dotfiles_repo` decides where the repository is. Only the "absent" branch
leads to a clone, which waits until Homebrew has provided `git`.

```mermaid
flowchart LR
    A{"ran from a file?<br>(BASH_SOURCE set)"}
    A -->|yes| B{"script dir has .git,<br>.stowrc or packages/?"}
    B -->|yes| V1[validate_repo]
    V1 -->|complete| U1(["use script dir"])
    V1 -->|"file missing"| X1(["exit 1"])
    B -->|no| C
    A -->|no| C{"$DOTFILES_DIR, else<br>~/Developer/dotfiles"}
    C -->|"has .git"| V2[validate_repo]
    V2 -->|complete| U2(["use repo dir"])
    V2 -->|"file missing"| X2(["exit 1"])
    C -->|"exists without .git"| X3(["exit 1: not a Git repository"])
    C -->|absent| CL(["print nothing: cloned after Homebrew"])
```
