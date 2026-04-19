# Mac Setup

Install Developer Tools
```
xcode-select --install
```

Install Brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /Users/scottmelhop/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> /Users/scottmelhop/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

Install GH Cli
```
brew install gh
```

Setup and Clone this Repo
```
mkdir -p ~/github/scottmelhop/setup
gh repo clone scottmelhop/setup ~/github/scottmelhop/setup
```

Install Visual Studio Code, open the app, and enable `code` from shell from Command Prompt.

Run the `mac.sh` script