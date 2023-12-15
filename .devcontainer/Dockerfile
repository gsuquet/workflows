FROM mcr.microsoft.com/devcontainers/python:3

# Install gnupg2
RUN apt-get update && apt-get install -y gnupg2 && apt-get clean -y && rm -rf /var/lib/apt/lists/*FROM mcr.microsoft.com/devcontainers/python:3

# Install gnupg2
RUN apt-get update && apt-get install -y gnupg2 && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install act
RUN curl -sSL https://raw.githubusercontent.com/nektos/act/master/install.sh | bash && rm -rf /var/lib/apt/lists/*
