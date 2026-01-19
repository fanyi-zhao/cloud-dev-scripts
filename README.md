# Cloud Dev Scripts

A collection of automated initialization scripts for setting up cloud development environments and services.

## Overview

This repository contains shell scripts that streamline the setup of various cloud services and development tools. Each script handles the configuration, installation, and initialization of specific services with minimal manual intervention.

## Scripts

### 1. `init_sglang_git.sh`

Sets up the SGLang project from scratch with all dependencies and configurations.

**What it does:**
- Installs system dependencies (libnuma1, git)
- Sets up pipx and uv (Python package managers)
- Clones the SGLang repository from GitHub
- Creates a Python virtual environment
- Installs the package in editable mode with test dependencies

**Prerequisites:**
- Ubuntu/Debian-based system with sudo access
- Python 3.8+ installed
- Internet connectivity

**Usage:**
```bash
bash init_sglang_git.sh
```

**Post-Installation:**
After successful installation, start the SGLang server:
```bash
cd sglang && uv run python3 -m sglang.launch_server --model-path meta-llama/Llama-3.1-8B-Instruct --host 0.0.0.0 --port 8000
```

---

### 2. `init_s3.sh`

Configures AWS S3 access by setting up AWS CLI and credentials.

**What it does:**
- Validates required environment variables
- Auto-installs AWS CLI v2 if not present
- Creates `.aws/credentials` and `.aws/config` files
- Sets appropriate file permissions (600) for security

**Prerequisites:**
- Ubuntu/Debian-based system with sudo access
- Internet connectivity

**Required Environment Variables:**
- `AWS_ACCESS_KEY`: Your AWS access key ID
- `AWS_SECRET_KEY`: Your AWS secret access key
- `AWS_REGION`: AWS region (e.g., `us-east-1`, `eu-west-1`)

**Usage:**
```bash
export AWS_ACCESS_KEY=your_access_key
export AWS_SECRET_KEY=your_secret_key
export AWS_REGION=us-east-1

bash init_s3.sh
```

---

### 3. `init_open-webui.sh`

Launches an Open WebUI Docker container connected to an OpenAI-compatible API.

**What it does:**
- Validates required environment variables
- Pulls and runs the Open WebUI Docker container
- Mounts persistent storage for data
- Exposes the web interface on port 8080

**Prerequisites:**
- Docker installed and running
- Internet connectivity
- OpenAI-compatible API running and accessible

**Required Environment Variables:**
- `OPENAI_API_BASE_URL`: Base URL of your OpenAI API (e.g., `http://localhost:8000/v1`)
- `OPENAI_API_KEY`: API key for authentication

**Usage:**
```bash
export OPENAI_API_BASE_URL=http://localhost:8000/v1
export OPENAI_API_KEY=your_api_key

bash init_open-webui.sh
```

The web interface will be accessible at `http://localhost:8080` (port may vary).

---

## Quick Start

### Setup SGLang + Open WebUI
#### Terminal 1 - Initialize and Start SGLang in Cloud:
```bash
bash init_sglang_git.sh
cd sglang
uv run python3 -m sglang.launch_server --model-path meta-llama/Llama-3.1-8B-Instruct --host 0.0.0.0 --port 8000
```

#### Terminal 2 - Setup Open WebUI (with cloud SGLang URL):
```bash
export OPENAI_API_BASE_URL=http://<CLOUD_HOST>:8000/v1
export OPENAI_API_KEY=test_key
bash init_open-webui.sh
```

Replace `<CLOUD_HOST>` with your cloud instance's public IP or domain name.

### Setup AWS S3

```bash
export AWS_ACCESS_KEY=your_key
export AWS_SECRET_KEY=your_secret
export AWS_REGION=us-east-1

bash init_s3.sh
```

## Features

- **Automated Setup**: Minimal manual configuration required
- **Error Handling**: Scripts exit on first error with `set -e`
- **Idempotent**: Safe to run multiple times
- **Dependency Management**: Auto-installs missing tools
- **Clear Output**: Informative messages and status indicators

## Error Handling

All scripts use `set -e` to exit immediately if any command fails. This ensures:
- No partial configurations
- Clear error identification
- Safe dependency installation

## Security Notes

- AWS credentials are stored in `~/.aws/` with restricted permissions (600)
- API keys should be provided via environment variables, not hardcoded
- Avoid committing sensitive information to the repository

## License

MIT License - See [LICENSE](LICENSE) file for details.

Copyright (c) 2026 FANYI ZHAO

## Contributing

Feel free to submit issues or pull requests to improve these initialization scripts.

---

**Note**: These scripts are designed for development and testing environments. For production deployments, consider additional security configurations and environment-specific customizations.
