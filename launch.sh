#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║                    PRAXISAI P900 LAUNCHER                       ║
# ║                    CozzyLabs © 2025-2026                        ║
# ╚══════════════════════════════════════════════════════════════════╝
#
# Usage:
#   ./launch.sh [OPTIONS]
#
# Options:
#   -m, --model      Model size: 0.8b, 2b, 4b, 9b (default: 9b)
#   -m, --mode       Mode: thinking, general, cli, reasoning (default: thinking)
#   -p, --port       Server port (default: 8001)
#   -h, --help       Show this help message
#
# Examples:
#   ./launch.sh                          # 9B thinking mode server
#   ./launch.sh -m 4b -m general         # 4B general mode server
#   ./launch.sh -m 2b --cli              # 2B CLI mode (non-thinking)
#   ./launch.sh -m 0.8b -m reasoning     # 0.8B reasoning CLI

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Default values
MODEL="9b"
MODE="thinking"
PORT="8001"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_banner() {
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ██████╗ ██╗      █████╗ ██████╗  █████╗                ║
    ║   ██╔══██╗██║     ██╔══██╗██╔══██╗██╔══██╗               ║
    ║   ██████╔╝██║     ███████║██████╔╝███████║               ║
    ║   ██╔═══╝ ██║     ██╔══██║██╔══██╗██╔══██║               ║
    ║   ██║     ███████╗██║  ██║██████╔╝██║  ██║               ║
    ║   ╚═╝     ╚══════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝               ║
    ║                                                           ║
    ║              P900 - Powered by Qwen3.5                    ║
    ║                  CozzyLabs © 2025-2026                    ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
}

show_help() {
    print_banner
    cat << 'EOF'

USAGE:
    ./launch.sh [OPTIONS]

OPTIONS:
    -m, --model SIZE   Model size: 0.8b, 2b, 4b, 9b (default: 9b)
    -M, --mode MODE    Mode: thinking, general, cli, reasoning (default: thinking)
    -p, --port PORT    Server port (default: 8001)
    -h, --help         Show this help message

MODES:
    thinking   - Server with reasoning/thinking enabled (use llama-server)
    general    - Server for general tasks with thinking enabled
    cli        - CLI mode for general tasks (non-thinking, use llama-cli)
    reasoning  - CLI mode for reasoning tasks (non-thinking, use llama-cli)

MODELS:
    0.8b       - Qwen3.5-0.8B (~1GB VRAM)
    2b         - Qwen3.5-2B (~2.5GB VRAM)
    4b         - Qwen3.5-4B (~5GB VRAM)
    9b         - Qwen3.5-9B (~12GB VRAM)

EXAMPLES:
    ./launch.sh                          # 9B thinking server
    ./launch.sh -m 4b -M general         # 4B general server
    ./launch.sh -m 2b -M cli             # 2B CLI mode
    ./launch.sh -m 0.8b -M reasoning    # 0.8B reasoning CLI
    ./launch.sh -m 9b -p 8080            # 9B on port 8080

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model)
            MODEL="$2"
            shift 2
            ;;
        -M|--mode)
            MODE="$2"
            shift 2
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Validate model
case $MODEL in
    0.8b|2b|4b|9b) ;;
    *)
        echo -e "${RED}Invalid model: $MODEL${NC}"
        echo -e "${YELLOW}Valid models: 0.8b, 2b, 4b, 9b${NC}"
        exit 1
        ;;
esac

# Validate mode
case $MODE in
    thinking|general|cli|reasoning) ;;
    *)
        echo -e "${RED}Invalid mode: $MODE${NC}"
        echo -e "${YELLOW}Valid modes: thinking, general, cli, reasoning${NC}"
        exit 1
        ;;
esac

# Print banner with selected options
print_banner
echo -e "${BLUE}Starting PraxisAI P900...${NC}"
echo -e "  Model: ${GREEN}$MODEL${NC}"
echo -e "  Mode:  ${GREEN}$MODE${NC}"
echo -e "  Port:  ${GREEN}$PORT${NC}"
echo ""

# Check for llama.cpp
if [ ! -d "llama.cpp" ]; then
    echo -e "${RED}ERROR: llama.cpp not found!${NC}"
    echo -e "${YELLOW}Please compile llama.cpp and place it in the project root.${NC}"
    echo ""
    echo "Build instructions:"
    echo "  apt-get update && apt-get install pciutils build-essential cmake curl libcurl4-openssl-dev -y"
    echo "  git clone https://github.com/ggml-org/llama.cpp"
    echo "  cmake llama.cpp -B llama.cpp/build -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON"
    echo "  cmake --build llama.cpp/build --config Release -j --clean-first --target llama-cli llama-mtmd-cli llama-server llama-gguf-split"
    echo "  cp llama.cpp/build/bin/llama-* llama.cpp"
    exit 1
fi

# Run the appropriate script
SCRIPT_PATH=""
case $MODE in
    thinking)
        SCRIPT_PATH="scripts/server/${MODEL}-thinking.sh"
        ;;
    general)
        SCRIPT_PATH="scripts/general/${MODEL}-general.sh"
        ;;
    cli)
        SCRIPT_PATH="scripts/cli/${MODEL}-general-cli.sh"
        ;;
    reasoning)
        SCRIPT_PATH="scripts/cli/${MODEL}-reasoning-cli.sh"
        ;;
esac

if [ -f "$SCRIPT_PATH" ]; then
    echo -e "${BLUE}Launching: $SCRIPT_PATH${NC}"
    echo ""
    chmod +x "$SCRIPT_PATH"
    sed -i "s/--port [0-9]*/--port $PORT/" "$SCRIPT_PATH"
    exec bash "$SCRIPT_PATH"
else
    echo -e "${RED}ERROR: Script not found: $SCRIPT_PATH${NC}"
    exit 1
fi
