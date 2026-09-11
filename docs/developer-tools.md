# Developer Tools

## Runtime policy

Use **Homebrew** for system-level CLI tools, applications and local services.

Use **mise** for language runtimes.

Global defaults are tracked in:

```text
mise/config.toml
```

Current defaults:

```toml
[tools]
node = "lts"
python = "3.14"
```

Install them with:

```bash
mise install
```

## Python packages

Use `uv` for Python package/project workflows when practical.

## GitHub

Authenticate GitHub CLI:

```bash
gh auth login
```

Verify:

```bash
gh auth status
```

## Git

Set your identity on a new machine:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

Do not commit credentials, tokens, `.env` files, or SSH private keys into this repository.

## Local services

The Brewfile installs:

```text
postgresql@17
redis
mkcert
stripe-cli
stripe-mock
```

Start a service only when needed, for example:

```bash
brew services start postgresql@17
brew services stop postgresql@17
```
