# 🛠 Modular Zsh Dotfiles (Apple Silicon, Znap)

This setup uses a symlinked `.zshrc` and a modular structure under `~/dotfiles/zsh`:

- `.zshrc` — entrypoint, just `source ~/dotfiles/zsh/init.zsh`
- `init.zsh` — main bootstrap (loads env, plugins, prompt, aliases, functions)
- `env.zsh` — env vars, Homebrew path, SSH agent, etc
- `plugins.zsh` — all plugin loads (using [Znap](https://github.com/marlonrichert/zsh-snap))
- `prompt.zsh` — prompt config (Pure, Starship, etc)
- `aliases.zsh` — your aliases
- `functions.zsh` — your functions

**Plugin repos are managed in `~/dotfiles/zsh/Repos/` and are not tracked by git.**

## 🚀 Quick Setup

```sh
# Clone your dotfiles
git clone https://github.com/<you>/dotfiles.git ~/dotfiles

# Run the bootstrap script
bash ~/dotfiles/bootstrap_dotfiles.sh

# (Re)start your shell
exec zsh
