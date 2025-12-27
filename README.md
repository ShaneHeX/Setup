# Setup

A minimal guide to prepare a development-ready macOS environment. Installing the software below improves productivity and maintainability.

## iTerm utilities

### Install oh-my-zsh

Zsh is a powerful Unix shell. Oh-My-Zsh is an open-source framework for managing Zsh configuration and plugins, improving the shell experience.

Install `oh-my-zsh` using the command below.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Package manager

Install `Homebrew` (macOS package manager).

Run the command below in a macOS Terminal.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Mirror
If your connection to upstream hosts is slow or unstable, consider using a closer mirror to speed package downloads (for example: [USTC](https://mirrors.ustc.edu.cn/help/brew.git.html)).

## Other development environment

- [Conda — env/conda/conda.md](env/conda/conda.md)
- [pip — env/pip/pip.md](env/pip/pip.md)

