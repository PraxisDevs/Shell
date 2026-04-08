# PraxisAI P900

AI assistant powered by Qwen3.5, branded as **PraxisAI P900** by CozzyLabs.

## Quick Start

```bash
# 1. Build llama.cpp
./build-llama.sh

# 2. Download models (optional - they'll download on first run)
./download-models.sh 9b

# 3. Launch PraxisAI
./launch.sh                    # 9B thinking server
./launch.sh -m 4b -M general    # 4B general mode
./launch.sh -m 2b --cli         # 2B CLI mode
```

## Model Variants

| Model | Parameters | VRAM | Quantized Size |
|-------|------------|------|----------------|
| Qwen3.5-0.8B | 0.8B | ~1GB | ~500MB |
| Qwen3.5-2B | 2B | ~2.5GB | ~1.2GB |
| Qwen3.5-4B | 4B | ~5GB | ~2.5GB |
| Qwen3.5-9B | 9B | ~12GB | ~5.5GB |

## Available Modes

- **thinking** - Reasoning mode with thinking enabled (llama-server)
- **general** - General tasks with thinking enabled (llama-server)
- **cli** - CLI mode for general tasks (llama-cli, non-thinking)
- **reasoning** - CLI mode for reasoning tasks (llama-cli, non-thinking)

## Project Structure

```
PraxisAI/
├── data-assets/
│   └── system-prompt.txt     # PraxisAI identity & instructions
├── config/
│   ├── models.env            # 0.8B configuration
│   ├── 2b.env                # 2B configuration
│   ├── 4b.env                # 4B configuration
│   └── 9b.env                # 9B configuration
├── scripts/
│   ├── server/               # Server scripts (thinking mode)
│   ├── cli/                  # CLI scripts (non-thinking)
│   └── general/              # General task scripts
├── models/                   # Downloaded GGUF models
├── llama.cpp/                # Compiled llama.cpp binaries
├── launch.sh                 # Main launcher
├── download-models.sh        # Model downloader
└── build-llama.sh            # Build script
```

## Requirements

- llama.cpp (compiled)
- CUDA (optional, for GPU acceleration)
- ~12GB RAM/VRAM for 9B model
- 256K context length support

## Identity

PraxisAI is configured with a custom identity based on the system prompt in `data-assets/system-prompt.txt`.

- **Name**: PraxisAI
- **Model**: P900 (built on Qwen3.5 foundation)
- **Creator**: CozzyLabs / Praxis Solutions
- **Owner**: itzC9 / C9 / Yuri
