#!/bin/bash

# Download the Homebrew installation script
INSTALL_SCRIPT=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)

# Check if the download was successful
if [ $? -eq 0 ]; then
  # Execute the installation script
  /bin/bash -c "$INSTALL_SCRIPT"
else
  echo "Failed to download the Homebrew installation script."
  exit 1
fi

# Install openfpgaloader using Homebrew
brew install openfpgaloader

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "openfpgaloader was installed successfully."
else
    echo "Failed to install openfpgaloader."
    exit 1
fi

# Install git using Homebrew
brew install git

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "git was installed successfully."
else
    echo "Failed to install git."
    exit 1
fi

# Install wget using Homebrew
brew install wget

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "wget was installed successfully."
else
    echo "Failed to install wget."
    exit 1
fi

# Install xz using Homebrew
brew install xz

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "xz was installed successfully."
else
    echo "Failed to install xz."
    exit 1
fi