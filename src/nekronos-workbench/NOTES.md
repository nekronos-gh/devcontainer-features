# Nekronos Workbench

Personal workspace bootstrap feature for Dev Containers.

## Usage in a project

To use this feature in your own Dev Container project, add it to your `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/nekronos-gh/devcontainer-features/nekronos-workbench:1": {
      "bundles": "python,latex"
    }
  }
}
```

## Available Bundles

- `python`: Installs Python 3, `uv`, and developer tools (`pyright`, `ruff`, `debugpy`).
- `latex`: Installs LaTeX dependencies, useful libraries (`texlive-full`),
  and developer tools for Neovim (`texlab`, `latexindent`, `chktex`).
