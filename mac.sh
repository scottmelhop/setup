#!/bin/bash

# =============================================================================
# Mac Setup Script
# Prerequisites: Xcode CLI tools, Homebrew, gh CLI (see mac.md)
# =============================================================================

FAILURES=()

# Run a command, echo what we're doing, and track failures
run() {
  local label="$1"
  shift
  echo ""
  echo "==> $label"
  if "$@"; then
    echo "    ✓ $label"
  else
    echo "    ✗ FAILED: $label"
    FAILURES+=("$label")
  fi
}

# Same as run but for commands that use pipes/redirects/shell builtins
run_shell() {
  local label="$1"
  shift
  echo ""
  echo "==> $label"
  if eval "$@"; then
    echo "    ✓ $label"
  else
    echo "    ✗ FAILED: $label"
    FAILURES+=("$label")
  fi
}

# =============================================================================
echo ""
echo "============================================"
echo "  Zsh Completions"
echo "============================================"
# =============================================================================

run "Install zsh-completions" brew install zsh-completions
run "Fix zsh-completions permissions" chmod go-w /opt/homebrew/share

# =============================================================================
echo ""
echo "============================================"
echo "  Shell Configuration (~/.zshrc.setup)"
echo "============================================"
# =============================================================================

SETUP_RC="$HOME/.zshrc.setup"
echo "==> Writing shell config to $SETUP_RC"
cat > "$SETUP_RC" << 'SHELL_CONFIG'
# --- Homebrew zsh-completions ---
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# --- Pyenv ---
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# --- GVM (Go Version Manager) ---
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# --- Build flags for zlib ---
export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"
export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"

# --- Poetry / local bin ---
export PATH="$HOME/.local/bin:$PATH"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# --- Locale ---
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# --- Git completions ---
fpath=(~/.zsh $fpath)

# --- Kubectl aliases ---
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kctx="kubectl config get-contexts"
alias kuse="kubectl config use-context"
alias kdel="kubectl delete"
alias kdesc="kubectl describe"
alias kl="kubectl logs"
alias kex="kubectl exec -it"
alias kpf="kubectl port-forward"
alias kcp="kubectl cp"
alias kroll="kubectl rollout"
alias kscale="kubectl scale"
alias ktop="kubectl top"

# --- Git aliases ---
alias commit="git commit -m "
alias push="git push "
alias pull="git pull "
alias status="git status "
alias co="git checkout "
alias branch="git branch "
alias merge="git merge "
alias rebase="git rebase "
alias stash="git stash "
alias nb="git checkout -b "

# Function: Push current branch and open PR creation page
pr() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  url=$(git push -u origin "$branch" 2>&1 | grep -Eo "https://github.com/[^ ]+/pull/new/[^ ]+")
  if [ -n "$url" ]; then
    open "$url"
  else
    echo "No PR link found in push output."
  fi
}
SHELL_CONFIG
echo "    ✓ Shell config written"

echo "==> Sourcing .zshrc.setup from .zshrc (idempotent)"
grep -q '.zshrc.setup' ~/.zshrc 2>/dev/null || \
  echo '[ -f "$HOME/.zshrc.setup" ] && source "$HOME/.zshrc.setup"' >> ~/.zshrc
echo "    ✓ .zshrc updated"

source "$SETUP_RC"

# =============================================================================
echo ""
echo "============================================"
echo "  Git Config"
echo "============================================"
# =============================================================================

run "Set git user.name" git config --global user.name "Scott Melhop"
run "Set git user.email" git config --global user.email "scott.melhop@volue.com"
run "Set git core.editor" git config --global core.editor "code --wait"

# =============================================================================
echo ""
echo "============================================"
echo "  Go (via gvm)"
echo "============================================"
# =============================================================================

if brew list --formula go &>/dev/null; then
  run "Uninstall Homebrew Go" brew uninstall --ignore-dependencies go
else
  echo ""
  echo "==> Homebrew Go not installed, skipping uninstall"
fi
sed -i '' '/GOROOT/d' ~/.zshrc
sed -i '' '/GOPATH/d' ~/.zshrc

run "Install gvm dependencies" brew install mercurial make binutils bison gcc
run_shell "Install gvm" 'bash < <(curl -sSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)'
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

run "Install Go 1.24.7 via gvm" gvm install go1.24.7 -B
run "Set Go 1.24.7 as default" gvm use go1.24.7 --default

# =============================================================================
echo ""
echo "============================================"
echo "  Clone Repos"
echo "============================================"
# =============================================================================

run "Clone optimus" gh repo clone optimeeringas/optimus ~/github/optimeering/optimus || true
run "Clone infrastructure" gh repo clone optimeeringas/infrastructure ~/github/optimeering/infrastructure || true
run "Clone mjolner" gh repo clone optimeeringas/mjolner ~/github/optimeering/mjolner || true
run "Clone optimeering-python-sdk" gh repo clone optimeeringas/optimeering-python-sdk ~/github/optimeering/optimeering-python-sdk || true
run "Clone prime" gh repo clone optimeeringas/prime ~/github/optimeering/prime || true

# =============================================================================
echo ""
echo "============================================"
echo "  Python (pyenv + poetry)"
echo "============================================"
# =============================================================================

run "Install pyenv" brew install pyenv
run "Install Python build dependencies" brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig

source "$SETUP_RC"
run "Install Python 3.11" pyenv install -s 3.11
run "Set Python 3.11 as global default" pyenv global 3.11

run_shell "Install Poetry" 'curl -sSL https://install.python-poetry.org | python3 -'
run "Configure Poetry virtualenvs in-project" poetry config virtualenvs.in-project true

# =============================================================================
echo ""
echo "============================================"
echo "  uv"
echo "============================================"
# =============================================================================

run_shell "Install uv" 'curl -LsSf https://astral.sh/uv/install.sh | sh'

# =============================================================================
echo ""
echo "============================================"
echo "  Node (nvm + pnpm)"
echo "============================================"
# =============================================================================

run "Install nvm" brew install nvm
run "Install pnpm" brew install pnpm

source "$SETUP_RC"
run "Install Node 22" nvm install 22
run "Set Node 22 as default" nvm alias default 22

# =============================================================================
echo ""
echo "============================================"
echo "  Azure CLI + Kubernetes"
echo "============================================"
# =============================================================================

run_shell "Install Azure CLI" 'brew update && brew install azure-cli'
run "Install kubectl" brew install kubernetes-cli
run "Install kubelogin" brew install kubelogin

# If a previous run used sudo az, ~/.azure may be owned by root.
# Fix ownership so `az login` can write its config.
if [ -d "$HOME/.azure" ] && [ "$(stat -f %u "$HOME/.azure")" != "$(id -u)" ]; then
  echo ""
  echo "==> Fixing ownership of ~/.azure (was root-owned)"
  sudo chown -R "$(id -u):$(id -g)" "$HOME/.azure"
fi

echo ""
echo "==> Checking Azure login"
if az account show &>/dev/null; then
  echo "    ✓ Already logged in as $(az account show --query user.name -o tsv)"
else
  echo "==> Azure login (device code — copy the code shown below into the URL)"
  az login --use-device-code
fi

if ! az account show &>/dev/null; then
  echo "    ✗ Azure login did not complete — skipping Azure setup"
  FAILURES+=("Azure login (run 'az login' manually then re-run Azure section)")
else
  run "Set Azure subscription" az account set --subscription f89df6fd-3521-4293-a210-ce8c8fa773a4
  run "Get AKS credentials (infra)" az aks get-credentials --resource-group infra --name infra --overwrite-existing
  run "Get AKS credentials (production)" az aks get-credentials --resource-group production --name production --overwrite-existing
  run "Get AKS credentials (staging)" az aks get-credentials --resource-group staging --name staging --overwrite-existing
  run "Convert kubeconfig for azurecli" kubelogin convert-kubeconfig -l azurecli
fi

run "Install helm" brew install helm
run "Install minikube" brew install minikube
run "Install argocd" brew install argocd
run "Install skaffold" brew install skaffold

# =============================================================================
echo ""
echo "============================================"
echo "  Container Tools"
echo "============================================"
# =============================================================================

run "Install crane" brew install crane
run "Install skopeo" brew install skopeo
run "Install oras" brew install oras

# =============================================================================
echo ""
echo "============================================"
echo "  Build Tools"
echo "============================================"
# =============================================================================

run "Install bazelisk" brew install bazelisk
run "Install buildifier" brew install buildifier
run "Install ibazel" brew install ibazel

# =============================================================================
echo ""
echo "============================================"
echo "  Other Tools"
echo "============================================"
# =============================================================================

run "Install postgresql@18" brew install postgresql@18
run "Install go-jsonnet" brew install go-jsonnet
run "Install grpcurl" brew install grpcurl
run "Install gnu-tar" brew install gnu-tar
run "Install dotnet" brew install dotnet

# =============================================================================
echo ""
echo "============================================"
echo "  Git Completions"
echo "============================================"
# =============================================================================

run_shell "Download git-completion.zsh" 'curl -sSf https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.git-completion.zsh'

# =============================================================================
echo ""
echo "============================================"
echo "  Casks"
echo "============================================"
# =============================================================================

run "Install Docker Desktop" brew install --cask docker
run "Install Claude Code" brew install --cask claude-code
run "Install Claude Desktop" brew install --cask claude

# =============================================================================
echo ""
echo "============================================"
echo "  VS Code Config & Extensions"
echo "============================================"
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR"

# Copy settings.json
if [ -f "$SCRIPT_DIR/vscode/settings.json" ]; then
  run "Copy VS Code settings.json" cp "$SCRIPT_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
else
  echo "    ⚠ vscode/settings.json not found in repo, skipping"
fi

# Copy keybindings.json
if [ -f "$SCRIPT_DIR/vscode/keybindings.json" ]; then
  run "Copy VS Code keybindings.json" cp "$SCRIPT_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
else
  echo "    ⚠ vscode/keybindings.json not found in repo, skipping"
fi

# Install extensions
EXTENSIONS_FILE="$SCRIPT_DIR/vscode-extensions.txt"
if [ -f "$EXTENSIONS_FILE" ]; then
  while IFS= read -r ext; do
    [ -z "$ext" ] && continue
    run "Install VS Code extension $ext" code --install-extension "$ext" --force
  done < "$EXTENSIONS_FILE"
else
  echo "    ⚠ $EXTENSIONS_FILE not found, skipping"
  FAILURES+=("VS Code extensions (vscode-extensions.txt missing)")
fi

# =============================================================================
echo ""
echo "============================================"
echo "  Claude Config"
echo "============================================"
# =============================================================================

CLAUDE_DIR="$HOME/.claude"
CLAUDE_DESKTOP_DIR="$HOME/Library/Application Support/Claude"
mkdir -p "$CLAUDE_DIR/projects" "$CLAUDE_DESKTOP_DIR"

# Copy Claude Code global settings.json
if [ -f "$SCRIPT_DIR/claude/settings.json" ]; then
  run "Copy Claude Code settings.json" cp "$SCRIPT_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json"
else
  echo "    ⚠ claude/settings.json not found in repo, skipping"
fi

# Copy Claude Desktop config
if [ -f "$SCRIPT_DIR/claude/desktop_config.json" ]; then
  run "Copy Claude Desktop config" cp "$SCRIPT_DIR/claude/desktop_config.json" "$CLAUDE_DESKTOP_DIR/claude_desktop_config.json"
else
  echo "    ⚠ claude/desktop_config.json not found in repo, skipping"
fi

# Copy per-project memory dirs
if [ -d "$SCRIPT_DIR/claude/projects" ]; then
  for src in "$SCRIPT_DIR"/claude/projects/*/memory; do
    [ -d "$src" ] || continue
    name=$(basename "$(dirname "$src")")
    dest="$CLAUDE_DIR/projects/$name/memory"
    mkdir -p "$dest"
    run "Copy Claude memory for $name" cp -R "$src/." "$dest/"
  done
else
  echo "    ⚠ claude/projects/ not found in repo, skipping"
fi

# =============================================================================
echo ""
echo "============================================"
echo "  Done!"
echo "============================================"
# =============================================================================

if [ ${#FAILURES[@]} -eq 0 ]; then
  echo ""
  echo "All steps completed successfully!"
else
  echo ""
  echo "The following steps FAILED:"
  echo ""
  for f in "${FAILURES[@]}"; do
    echo "  ✗ $f"
  done
  echo ""
  echo "Review the output above and re-run or fix manually."
fi

echo ""
echo "Restart your terminal or run: source ~/.zshrc"
