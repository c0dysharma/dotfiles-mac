# dotfiles

Personal macOS dotfiles managed with a bare git repository. Tracks Neovim (LazyVim), Zsh (oh-my-zsh), tmux, and git config.

## Tracked files

- `.zshrc` — Zsh config with oh-my-zsh
- `.tmux.conf` — tmux config
- `.gitconfig` — global git config
- `.config/nvim/` — Neovim config (LazyVim)

## Setup on a new machine

### 1. Install prerequisites

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# oh-my-zsh (install before checking out dotfiles so .zshrc doesn't conflict)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Neovim, tmux
brew install neovim tmux
```

### 2. Clone the dotfiles repo

```bash
git clone --bare https://github.com/c0dysharma/dotfiles-mac.git $HOME/.dotfiles
```

### 3. Set up the alias

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 4. Checkout files

If existing default files conflict (e.g. `.zshrc` from oh-my-zsh install), back them up first:

```bash
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | grep "^\s" | awk '{print $1}' | xargs -I{} mv {} ~/.dotfiles-backup/{}
```

Then checkout:

```bash
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

### 5. Add the alias permanently

The `.zshrc` you just checked out already contains the alias. Reload it:

```bash
source ~/.zshrc
```

### 6. Authenticate with GitHub (macOS Keychain — no key files)

```bash
git config --global credential.helper osxkeychain
```

Generate a Personal Access Token at **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)** with `repo` scope. On first push you'll be prompted once — the token is stored in Keychain and never asked again.

---

## Daily usage

```bash
# Check what's changed
dotfiles status

# Stage a file
dotfiles add ~/.zshrc

# Commit
dotfiles commit -m "update zsh aliases"

# Push
dotfiles push
```

## Adding a new file to track

```bash
dotfiles add ~/.config/some-tool/config
dotfiles commit -m "track some-tool config"
dotfiles push
```

## What is NOT tracked

- `~/.oh-my-zsh/` — install fresh via the installer above
- `~/.local/share/nvim/` — LazyVim plugin cache, auto-generated on first launch
- Any files with secrets or tokens
