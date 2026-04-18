#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null > /dev/null
}

# User-friendly message functions with color coding
print_info() {
    echo -e "\033[1;36m➜\033[0m  \033[1m$1\033[0m"
}

print_success() {
    echo -e "\033[1;32m✓\033[0m  \033[1;32m$1\033[0m"
}

print_warning() {
    echo -e "\033[1;33m⚠\033[0m  \033[1;33m$1\033[0m"
}

print_fatal() {
    echo -e "\033[1;31m✗\033[0m  \033[1;31m$1\033[0m"
    exit 1
}

# Set error handling
set -o pipefail

print_info "Starting development environment setup..."
echo ""

# Prompt the user to enter their GitHub username for authentication
read -p $'\033[1;36m➜\033[0m  GitHub username: ' GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
    print_fatal "GitHub username cannot be empty."
fi
GITHUB_MAIN_PAGE_URL="https://github.com/$GITHUB_USERNAME"

# Prompt the user to enter their email address for SSH key generation
read -p $'\033[1;36m➜\033[0m  Email address: ' USER_EMAIL
if [ -z "$USER_EMAIL" ]; then
    print_fatal "Email address cannot be empty."
fi

# Prompt the user to enter a hostname for the SSH key title
read -p $'\033[1;36m➜\033[0m  SSH key title (e.g., MacBook Pro): ' GITHUB_SSH_KEY_TITLE
if [ -z "$GITHUB_SSH_KEY_TITLE" ]; then
    GITHUB_SSH_KEY_TITLE="$(hostname)"
fi

echo ""

# Install Homebrew if not installed
if ! command_exists brew; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null || {
        print_fatal "Failed to install Homebrew. Please check your internet connection and try again."
    }
    print_success "Homebrew installed successfully."
else
    print_success "Homebrew is already installed."
fi

# Ensure Homebrew is up-to-date
print_info "Updating Homebrew..."
brew update > /dev/null || {
    echo "$output"
    print_fatal "Failed to update Homebrew. Please check your internet connection and try again."
}

# Install gh (GitHub CLI) if not installed
if ! command_exists gh; then
    print_info "Installing GitHub CLI (gh)..."
    brew install gh > /dev/null || {
        print_fatal "Failed to install GitHub CLI. Please try again."
    }
    print_success "GitHub CLI installed."
else
    print_success "GitHub CLI (gh) is already installed."
fi

# Install chezmoi if not installed
if ! command_exists chezmoi; then
    print_info "Installing chezmoi..."
    brew install chezmoi > /dev/null || {
        print_fatal "Failed to install chezmoi. Please try again."
    }
    print_success "chezmoi installed."
else
    print_success "chezmoi is already installed."
fi

# Check GitHub authentication status
print_info "Checking GitHub authentication..."
if gh auth status > /dev/null; then
    print_success "Already authenticated with GitHub."
else
    print_warning "Not authenticated with GitHub. Please log in."
    gh auth login --skip-ssh-key || {
        print_fatal "GitHub authentication failed. Please try again."
    }
    print_success "GitHub authentication successful."
fi

# Generate SSH key if connection to GitHub fails
SSH_KEY="$HOME/.ssh/id_ed25519"

print_info "Checking SSH connection to GitHub..."
if ssh -T git@github.com > /dev/null 2>&1; then
    print_info "SSH connection to GitHub failed. Generating a new SSH key..."
    if [ ! -d "$HOME/.ssh" ]; then
        mkdir "$HOME/.ssh" || {
            print_fatal "Failed to create .ssh directory. Please check permissions and try again."
        }
    fi

    ssh-keygen -t ed25519 -f "$SSH_KEY" -C "$USER_EMAIL" -N "" > /dev/null || {
        print_fatal "Failed to generate SSH key. Please try again."
    }
    print_success "SSH key generated at $SSH_KEY.pub."
    
    # Add SSH key to GitHub
    print_info "Adding SSH key to GitHub..."
    gh ssh-key add "$SSH_KEY.pub" --title "$GITHUB_SSH_KEY_TITLE" > /dev/null || {
        print_fatal "Failed to add SSH key to GitHub. Please try again."
    }
    print_success "SSH key added to GitHub."
else
    print_success "SSH connection to GitHub is working."
fi

# Clone and apply dotfiles using chezmoi
print_info "Setting up dotfiles and applying with chezmoi..."
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    chezmoi init "$GITHUB_MAIN_PAGE_URL/dotfiles" --apply > /dev/null || {
        print_fatal "Failed to apply dotfiles. Please check your dotfiles repository and try again."
    }
    print_success "Dotfiles applied successfully."
else
    print_success "Dotfiles are already applied."
fi

echo "------------------------------------"
print_success "Development environment setup complete!"
print_info "You can now start using your configured environment. Happy coding!"

