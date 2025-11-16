Dockerized Self-Hosted GitHub Actions Runner
============================================

This repository contains a Dockerfile and entrypoint script to set up a **self-hosted GitHub Actions runner** on a Linux host (e.g., Ubuntu, Raspberry Pi, etc.).

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
git clone https://github.com/jackammon/docker-self-hosted-runner.git
cd docker-self-hosted-runner
```

### 2\. Add .env
Create the .env file
```
nano .env
```

Add the enviroment variables and the value for each
```
GITHUB_RUNNER_TOKEN=replaceme
GITHUB_RUNNER_URL=replaceme
RUNNER_NAME=pi-runner
RUNNER_LABELS=self-hosted,linux,arm64,pi-runner
```

| Variable | Description | Required |
| --- | --- | --- |
| `GITHUB_RUNNER_URL` | The URL of your GitHub repository or organization. E.g. `https://github.com/<user>/<repo>` or `https://github.com/<org>`. | **Yes** |
| `GITHUB_RUNNER_TOKEN` | Runner registration token from GitHub. Go to **Settings** > **Actions** > **Runners** to generate. | **Yes** |
| `RUNNER_NAME` | Custom name for this runner. Defaults to the container's hostname if not set. | No |
| `RUNNER_LABELS` | Comma-separated labels to assign to the runner (e.g. `self-hosted,linux,arm64`). Defaults to `self-hosted,linux,arm64`. | No |



* * * * *

Usage
-----
Build the Container
```
docker-compose build --no-cache
```

Running the Container

```
docker-compose up -d
```

Restarting the container
```
docker-compose down && docker-compose up -d
```

