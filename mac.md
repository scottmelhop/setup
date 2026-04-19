# Mac Setup

This repo captures everything needed to bring a Mac up to Scott's working environment:

- Brew formulae and casks (CLIs, Docker, Claude Code, etc.)
- Shell configuration (`~/.zshrc.setup` with aliases, env, pyenv/nvm/gvm hooks)
- Language toolchains (Go via gvm, Python via pyenv, Node via nvm)
- Azure CLI + AKS credentials + kubectl/kubelogin
- Repo clones (optimus, infrastructure, mjolner, optimeering-python-sdk, prime)
- VS Code settings, keybindings, and extensions
- Claude Code / Claude Desktop settings + per-project memory

---

## Scenarios

### Scenario 1 — Fresh machine (set up from scratch)

One-time bootstrap before running the main script:

**1. Install Xcode Command Line Tools**
```bash
xcode-select --install
```

**2. Install Homebrew**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

**3. Install GitHub CLI and log in**
```bash
brew install gh
gh auth login
```

**4. Clone this repo**
```bash
mkdir -p ~/github/scottmelhop
gh repo clone scottmelhop/setup ~/github/scottmelhop/setup
```

**5. Install VS Code**, launch it once, then run **Shell Command: Install 'code' command in PATH** from the Command Palette (`Cmd+Shift+P`).

**6. Run the main script**
```bash
cd ~/github/scottmelhop/setup
./mac.sh
```

The script is idempotent — safe to re-run if anything fails. During the Azure section it will either reuse an existing login or launch an `az login --use-device-code` flow (prints a URL + code to paste into any browser).

---

### Scenario 2 — Snapshot current machine before migrating

Run these on the **old** machine to capture the latest state, then commit and push so the new machine can pull it.

```bash
cd ~/github/scottmelhop/setup
./export-vscode.sh   # extensions, settings.json, keybindings.json
./export-claude.sh   # Claude Code settings + per-project memory + desktop config
git add -A
git commit -m "Snapshot before migration"
git push
```

Then follow Scenario 1 on the new machine.

---

### Scenario 3 — Re-run on existing machine (sync updates)

Pull the latest, then re-run whatever you need:

```bash
cd ~/github/scottmelhop/setup
git pull
./mac.sh                                    # everything (idempotent)
```

Or just the parts you care about:
```bash
cp claude/settings.json ~/.claude/settings.json        # just Claude settings
cp vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
xargs -L1 code --install-extension --force < vscode-extensions.txt
```

---

## What's in this repo

| Path | Purpose |
|---|---|
| `mac.sh` | Main setup script |
| `mac.md` | This file |
| `export-vscode.sh` | Snapshot VS Code config into `vscode/` + `vscode-extensions.txt` |
| `export-claude.sh` | Snapshot Claude config into `claude/` |
| `vscode/settings.json` | Global VS Code user settings |
| `vscode/keybindings.json` | Global VS Code keybindings |
| `vscode-extensions.txt` | List of installed VS Code extensions |
| `claude/settings.json` | Claude Code global settings (permissions, model) |
| `claude/desktop_config.json` | Claude Desktop config |
| `claude/projects/*/memory/` | Per-project Claude memory files |

---

## Notes

- `mac.sh` prints progress as it runs and collects failures into a summary at the end.
- Safe to re-run: `brew install` is no-op if present; pyenv/nvm skip existing versions; Azure section skips login if already authenticated; repo clones fail harmlessly if the directory exists.
- Azure: if a previous run used `sudo az aks install-cli` it may have left `~/.azure` owned by root. The script detects and fixes this automatically.
- VS Code and Claude configs are **overwritten** from the repo on every `mac.sh` run — if you tweak them locally, run the relevant `export-*.sh` script and commit before re-running `mac.sh`.
