#!/bin/bash
# PraxisAI P900 - Model Downloader
# Downloads GGUF models from Hugging Face

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MODELS_DIR="$PROJECT_ROOT/models"

mkdir -p "$MODELS_DIR"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              PRAXISAI P900 MODEL DOWNLOADER              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

download_model() {
    local size=$1
    local repo="unsloth/Qwen3.5-${size}-GGUF"
    
    echo -e "\033[1;36mDownloading Qwen3.5-${size}...\033[0m"
    echo "Repository: $repo"
    echo ""
    
    hf download "$repo" \
        --local-dir "$MODELS_DIR/Qwen3.5-${size}-GGUF" \
        --include "*mmproj-F16*" \
        --include "*UD-Q4_K_XL*" \
        2>/dev/null || \
    hf download "$repo" \
        --local-dir "$MODELS_DIR/Qwen3.5-${size}-GGUF" \
        --include "*UD-Q4_K_XL*"
    
    echo -e "\033[0;32m✓ Qwen3.5-${size} downloaded!\033[0m"
}

if [ $# -eq 0 ]; then
    echo "Available models to download:"
    echo "  0.8B - Qwen3.5-0.8B (~500MB)"
    echo "  2B   - Qwen3.5-2B (~1.2GB)"
    echo "  4B   - Qwen3.5-4B (~2.5GB)"
    echo "  9B   - Qwen3.5-9B (~5.5GB)"
    echo ""
    echo "Usage: $0 [0.8b|2b|4b|9b|all]"
    echo ""
    read -p "Enter model size to download (or 'all'): " choice
    
    case $choice in
        0.8b|0.8B) download_model "0.8B" ;;
        2b|2B)     download_model "2B" ;;
        4b|4B)     download_model "4B" ;;
        9b|9B)     download_model "9B" ;;
        all|All)   
            download_model "0.8B"
            download_model "2B"
            download_model "4B"
            download_model "9B"
            ;;
        *)         echo "Invalid choice" ;;
    esac
else
    case $1 in
        0.8b|0.8B) download_model "0.8B" ;;
        2b|2B)     download_model "2B" ;;
        4b|4B)     download_model "4B" ;;
        9b|9B)     download_model "9B" ;;
        all|All)   
            download_model "0.8B"
            download_model "2B"
            download_model "4B"
            download_model "9B"
            ;;
        *)         echo "Invalid model: $1" ;;
    esac
fi

echo ""
echo -e "\033[0;32m✓ All downloads complete!\033[0m"
echo "Models saved to: $MODELS_DIR"
