# Introduction

Set up a production-ready development environment in one command.

Help me to quickly get started with a consistent and efficient development environment on macOS.

## Architecture

The project depends on the following components:

- **Homebrew**: A package manager for macOS that simplifies the installation of software and tools.
- **gh**: The GitHub CLI tool that allows you to interact with GitHub from the command line.
- **chezmoi**: A dotfile manager that helps you manage your configuration files across multiple machines.

Other components should be installed in macOS by default, such as `git`, `zsh`, and `curl`.

The installation process is automated using a shell script:

1. Promt me to enter my username, email address and hostname, which will be used for SSH key generation and git configuration.
2. The script checks for the presence of `Homebrew` and installs it if it's not already installed.
3. It then uses `Homebrew` to install `gh` and `chezmoi`.
4. Check `gh` authentication status:
    - If authenticated, it proceeds to the next step.
    - If not authenticated, it prompts me to authenticate with GitHub using `gh auth login --skip-ssh-key`.
5. [Check SSH connection](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection), generate an new ssh key (using `ed25519` algorithm) and upload it to GitHub if connection fails.
6. Clone the private [dotfiles](https://github.com/ShaneHeX/dotfiles) repository using `chezmoi` and apply the configuration. The `dotfiles` repository should contain all the necessary configuration files, after configuration files are applied, the after-applied script will be executed by `chezmoi` to install additional tools and perform any necessary setup.

    (***Note: The `dotfiles` repository must be private and the user must have access to it for the script to work properly.***)

When all steps are completed, I will have a fully set up development environment with all the necessary tools and configurations in place.

## Usage

Run the following command in your terminal to execute the installation script:

```bash
curl -sL https://raw.githubusercontent.com/ShaneHeX/Setup/main/install.sh | bash
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.