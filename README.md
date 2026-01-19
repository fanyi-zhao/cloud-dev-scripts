# Cloud LLM Dev Scripts

**Instant setup for cloud-based LLM development.**  
Skip the environment configuration and start coding and testing in seconds.

## ⚡ Quick Start

### SGLang (with Mooncake & Router)
Sets up SGLang dev environment with P/D disaggregation dependencies.
```bash
cd sglang
source init_sglang_git.sh
```
*See [SGLang Cookbook](sglang/SGLANG_COOKBOOK.md) for single-node and distributed launch instructions.*

### AWS S3
Configures AWS CLI and credentials securely.
```bash
export AWS_ACCESS_KEY=your_key
export AWS_SECRET_KEY=your_secret
export AWS_REGION=your_region
source init_s3.sh
```

### Open WebUI
Launches a UI for your LLM API.
```bash
export OPENAI_API_BASE_URL=http://localhost:8000/v1
export OPENAI_API_KEY=sk-... 
source init_open-webui.sh
```

## 📜 Included Scripts

| Script | Description |
| :--- | :--- |
| `init_sglang_git.sh` | Installs **SGLang**, Mooncake, and Router. Sets up `pipx`, `uv`, and virtual environment. |
| `init_s3.sh` | Installs **AWS CLI** and configures credentials securely in `~/.aws/`. |
| `init_open-webui.sh` | Launches **Open WebUI** in Docker connected to your model API. |

## 🔗 References
*   [SGLang Cookbook](sglang/SGLANG_COOKBOOK.md)
*   [SGLang GitHub](https://github.com/sgl-project/sglang)
*   [Open WebUI GitHub](https://github.com/open-webui/open-webui)

---
*Created by Fanyi Zhao (2026). MIT License.*
