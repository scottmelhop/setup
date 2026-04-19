# Uninstall Homebrew Go if present
brew uninstall --ignore-dependencies go || true

# Remove GOROOT and GOPATH from shell profiles
sed -i '' '/GOROOT/d' ~/.zshrc
sed -i '' '/GOPATH/d' ~/.zshrc

# Install gvm dependencies
git --version || brew install git
brew install mercurial make binutils bison gcc

# Install gvm
bash < <(curl -sSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

# Source gvm in current shell and add to .zshrc
echo '[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"' >> ~/.zshrc
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

gvm install go1.24.7
gvm use go1.24.7 --default

gh repo clone optimeeringas/optimus ~/github/optimeering/optimus
gh repo clone optimeeringas/infrastructure ~/github/optimeering/infrastructure
gh repo clone optimeeringas/mjolner ~/github/optimeering/mjolner
gh repo clone optimeeringas/optimeering-python-sdk ~/github/optimeering/optimeering-python-sdk

brew install pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc

brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig



echo 'export LDFLAGS="-L/opt/homebrew/opt/zlib/lib"' >> ~/.zshrc
echo 'export CPPFLAGS="-I/opt/homebrew/opt/zlib/include"' >> ~/.zshrc
echo 'export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig"' >> ~/.zshrc

. ~/.zshrc 

pyenv install 3.11
pyenv global 3.11

curl -sSL https://install.python-poetry.org | python3 -

echo 'export PATH="/Users/scottmelhop/.local/bin:$PATH"' >> ~/.zshrc

. ~/.zshrc

# Create the virtualenv inside the project’s root directory
poetry config virtualenvs.in-project true

brew update && brew install azure-cli

sudo az aks install-cli

az login
az account set --subscription f89df6fd-3521-4293-a210-ce8c8fa773a4
az aks get-credentials --resource-group infra --name infra --overwrite-existing
az aks get-credentials --resource-group production --name production --overwrite-existing
az aks get-credentials --resource-group staging --name staging --overwrite-existing
kubelogin convert-kubeconfig -l azurecli

echo 'alias k="kubectl"' >> ~/.zshrc
echo 'alias kgp="kubectl get pods"' >> ~/.zshrc
echo 'alias kgs="kubectl get svc"' >> ~/.zshrc
echo 'alias kgd="kubectl get deployments"' >> ~/.zshrc
echo 'alias kgn="kubectl get nodes"' >> ~/.zshrc
echo 'alias kctx="kubectl config get-contexts"' >> ~/.zshrc
echo 'alias kuse="kubectl config use-context"' >> ~/.zshrc
echo 'alias kdel="kubectl delete"' >> ~/.zshrc
echo 'alias kdesc="kubectl describe"' >> ~/.zshrc
echo 'alias kl="kubectl logs"' >> ~/.zshrc
echo 'alias kex="kubectl exec -it"' >> ~/.zshrc
echo 'alias kpf="kubectl port-forward"' >> ~/.zshrc
echo 'alias kcp="kubectl cp"' >> ~/.zshrc
echo 'alias kroll="kubectl rollout"' >> ~/.zshrc
echo 'alias kscale="kubectl scale"' >> ~/.zshrc
echo 'alias ktop="kubectl top"' >> ~/.zshrc

. ~/.zshrc

brew install helm


# Install buildifier (Bazel build file formatter)
# See: https://github.com/bazelbuild/buildtools/releases

BUILDTOOLS_VERSION="6.4.0"  # Update as needed
ARCH="$(uname -m)"
if [ "$ARCH" = "arm64" ]; then
  BUILDIFIER_URL="https://github.com/bazelbuild/buildtools/releases/download/v$BUILDTOOLS_VERSION/buildifier-darwin-arm64"
else
  BUILDIFIER_URL="https://github.com/bazelbuild/buildtools/releases/download/v$BUILDTOOLS_VERSION/buildifier-darwin-amd64"
fi
mkdir -p "$HOME/.local/bin"
curl -L "$BUILDIFIER_URL" -o "$HOME/.local/bin/buildifier"
chmod +x "$HOME/.local/bin/buildifier"
