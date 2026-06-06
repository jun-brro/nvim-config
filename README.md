# AstroNvim Template

> If you ran the clone below and got **`nvim: command not found`**, Neovim itself
> isn't installed yet (cloning only places the *config*). Follow
> [Installing Neovim](#installing-neovim) first.

#### Clone the repository

```shell
git clone https://github.com/jun-brro/nvim-config ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

## Installing Neovim

This repo is only the configuration — you also need the `nvim` binary on your
`PATH`.

### Linux (no sudo / HPC / shared cluster)

Install a prebuilt release into `~/.local` and link it into `~/.local/bin`
(no root required):

```shell
# 1. download the latest stable release (x86_64, glibc >= 2.34)
curl -fL -o /tmp/nvim.tar.gz \
  https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# 2. unpack it under ~/.local/opt
mkdir -p ~/.local/opt ~/.local/bin
tar xzf /tmp/nvim.tar.gz -C ~/.local/opt

# 3. symlink the binary onto your PATH
ln -sf ~/.local/opt/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
```

### Linux (with sudo)

```shell
sudo apt install neovim     # Debian/Ubuntu
sudo dnf install neovim     # Fedora
```

### macOS

```shell
brew install neovim
```

## Applying the PATH (route setup)

The symlink above lives in `~/.local/bin`, so that directory must be on your
`PATH`. Add it to your shell startup file **once**:

```shell
# bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

Then reload the shell so the change takes effect:

```shell
source ~/.bashrc      # or: source ~/.zshrc
# or simply open a new terminal
```

Verify it is found:

```shell
which nvim            # -> ~/.local/bin/nvim
nvim --version        # -> NVIM v0.12.x ...
```

Now run `nvim` — on the first launch lazy.nvim bootstraps and installs all
plugins automatically.
