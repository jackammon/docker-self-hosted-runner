Dockerized Self-Hosted GitHub Actions Runner
============================================

This repository contains a Dockerfile and entrypoint script to set up a **self-hosted GitHub Actions runner** on a Linux host (e.g., Ubuntu, Raspberry Pi, etc.).

Table of Contents
-----------------

1.  [Overview](#overview)
2.  [Prerequisites](#prerequisites)
3.  [Installation](#installation)
    1.  [Cloning the Repository](#1-cloning-the-repository)
    2.  [Building the Docker Image](#2-building-the-docker-image)
4.  [Usage](#usage)
    1.  [Environment Variables](#1-environment-variables)
    2.  [Running the Container](#2-running-the-container)
5.  [Docker Compose (Optional)](#docker-compose-optional)
6.  [Updating the Runner](#updating-the-runner)

* * * * *

Overview
--------

This setup allows you to:

-   Self-host your own GitHub Actions runner on a Linux host.
-   Run the runner inside a Docker container.
-   Easily manage the runner lifecycle (start, stop, remove, rebuild).
-   Capture logs using Docker's built-in tooling or third-party solutions.
-   Label and group runners for easier job assignment.

* * * * *

Features
--------

-   **ARM/ARM64-compatible**: Ideal for Raspberry Pi, NVIDIA Jetson boards, or other ARM-based systems.
-   **Automatic registration** with your GitHub repository or organization.
-   **Graceful de-registration** on container stop, preventing stale runners in your GitHub settings.
-   **Configurable labels** for finer control in your GitHub Action workflows.

* * * * *

Prerequisites
-------------

1.  **A Linux host** with Docker installed (e.g., Ubuntu, Raspberry Pi OS, etc.).
    -   If you're on a Raspberry Pi, ensure you have Docker installed and are using the correct architecture (ARM/ARM64).
2.  **GitHub account** with permissions to create and manage self-hosted runners.
3.  **Runner registration token** (can be generated from your GitHub repository or organization under **Settings** > **Actions** > **Runners** > **New self-hosted runner**).

* * * * *

Installation
------------

### 1\. Cloning the Repository

```bash
git clone https://github.com/<YourUsername>/docker-github-runner.git
cd docker-github-runner
```

### 2\. Building the Docker Image

```
docker build -t runner:latest .
```

-   `runner:latest` is a tag for the locally built image.
-   The build process will:
    -   Use the `ubuntu:22.04` base image (customize as needed).
    -   Install required dependencies (`curl`, `jq`, `tar`, `git`, etc.).
    -   Download the GitHub Actions runner for the specified architecture/runner version.
    -   Copy `entrypoint.sh` and set it as the container's entrypoint.

* * * * *

Usage
-----

### 1\. Environment Variables

| Variable | Description | Required |
| --- | --- | --- |
| `GITHUB_RUNNER_URL` | The URL of your GitHub repository or organization. E.g. `https://github.com/<user>/<repo>` or `https://github.com/<org>`. | **Yes** |
| `GITHUB_RUNNER_TOKEN` | Runner registration token from GitHub. Go to **Settings** > **Actions** > **Runners** to generate. | **Yes** |
| `RUNNER_NAME` | Custom name for this runner. Defaults to the container's hostname if not set. | No |
| `RUNNER_LABELS` | Comma-separated labels to assign to the runner (e.g. `self-hosted,linux,arm64`). Defaults to `self-hosted,linux,arm64`. | No |

### 2\. Running the Container

#### Example: Repository-Level Runner

```
docker run -d\
  --name gh-runner\
  --restart always\
  -e GITHUB_RUNNER_URL="https://github.com/<YOUR_USER>/<YOUR_REPO>"\
  -e GITHUB_RUNNER_TOKEN="<YOUR_TOKEN_HERE>"\
  -e RUNNER_NAME="my-pi-runner"\
  -e RUNNER_LABELS="self-hosted,linux,arm64"\
  runner:latest
  ```

#### Example: Organization-Level Runner

```
docker run -d\
  --name gh-runner\
  --restart always\
  -e GITHUB_RUNNER_URL="https://github.com/<YOUR_ORG>"\
  -e GITHUB_RUNNER_TOKEN="<YOUR_TOKEN_HERE>"\
  -e RUNNER_NAME="my-pi-org-runner"\
  -e RUNNER_LABELS="self-hosted,linux,arm64"\
  runner:latest
  ```

-   `--restart always` ensures the container restarts automatically on reboot or in case of unexpected stops.
-   Once the container starts, it will attempt to register with GitHub automatically.
-   If the token or URL are invalid/expired, the container will exit with an error.

* * * * *

Docker Compose (Optional)
-------------------------

You can manage the runner more conveniently with Docker Compose:

1.  **Create a `docker-compose.yml`** in the project root:

    ```
    version: '3.8'

    services:
      github-runner:
        image: runner:latest
        container_name: github-runner
        restart: always
        environment:
          GITHUB_RUNNER_URL: "https://github.com/<YOUR_USER>/<YOUR_REPO>"
          GITHUB_RUNNER_TOKEN: "<YOUR_TOKEN_HERE>"
          RUNNER_NAME: "my-compose-runner"
          RUNNER_LABELS: "self-hosted,linux,arm64"

2.  **Run**:

    ```
    docker compose up -d`

-   The runner should appear under **Settings** > **Actions** > **Runners**.
-   This approach can be integrated with other services (databases, web apps, etc.) for a cohesive dockerized environment.

* * * * *

Updating the Runner
-------------------

The GitHub Actions runner is updated regularly. To update:

1.  **Check the latest runner version** on [GitHub Actions Runner Releases](https://github.com/actions/runner/releases).

2.  Update `RUNNER_VERSION` in the Dockerfile to match the latest release.

3.  Rebuild the image:

    ```
    docker build -t runner:latest .

4.  Redeploy the container:

    ```
    docker stop gh-runner && docker rm gh-runner
    docker run -d --restart always ... runner:latest

* * * * *
