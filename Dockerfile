FROM ubuntu:22.04

ARG RUNNER_VERSION="2.317.0"
ARG RUNNER_ARCH="arm64"

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    ca-certificates \
    tar \
    sudo \
    git \
    docker.io \  # Added Docker CLI
    && rm -rf /var/lib/apt/lists/*

# Create user without password
RUN useradd -m docker && \
    usermod -aG sudo docker && \
    usermod -aG docker docker && \
    echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER docker
WORKDIR /home/docker

# Download runner
RUN curl -L \
  "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
  -o runner.tar.gz \
  && tar xzf runner.tar.gz \
  && rm runner.tar.gz

# Install docker-compose
RUN sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-aarch64" \
    -o /usr/local/bin/docker-compose \
    && sudo chmod +x /usr/local/bin/docker-compose

COPY entrypoint.sh .
RUN sudo chmod +x entrypoint.sh

ENTRYPOINT ["/home/docker/entrypoint.sh"]
