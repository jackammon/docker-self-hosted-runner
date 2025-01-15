FROM ubuntu:22.04

# Set ARGs for version and architecture
ARG RUNNER_VERSION="2.309.0"
# For Raspberry Pi 5, we need 'arm64'
ARG RUNNER_ARCH="arm64"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    ca-certificates \
    tar \
    sudo \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a user for the runner
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Switch to the user
USER docker
WORKDIR /home/docker

# Download the GitHub Actions runner
RUN curl -L \
  "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
  -o "actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
  && tar xzf "actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
  && rm "actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz"

# Copy entrypoint script
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/home/docker/entrypoint.sh"]
