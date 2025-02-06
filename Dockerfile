FROM ubuntu:22.04

ARG RUNNER_VERSION="2.317.0"
ARG RUNNER_ARCH="arm64"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    ca-certificates \
    tar \
    sudo \
    git \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Create user "docker" using the preexisting 'docker' group and add to sudoers
RUN useradd -m -g docker docker && \
    usermod -aG sudo docker && \
    echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user and set the working directory
USER docker
WORKDIR /home/docker

# Download and extract the GitHub Actions runner
RUN curl -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
    -o runner.tar.gz && \
    tar xzf runner.tar.gz && \
    rm runner.tar.gz

# Install docker-compose (as root using sudo)
RUN sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-aarch64" \
    -o /usr/local/bin/docker-compose && \
    sudo chmod +x /usr/local/bin/docker-compose

# Copy the entrypoint script to a location that won’t be affected by volume mounts
USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Return to the non-root user
USER docker
WORKDIR /home/docker

# Set the container entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
