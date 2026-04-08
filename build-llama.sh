#!/bin/bash
# PraxisAI P900 - llama.cpp Build Script
# Builds llama.cpp with CUDA support (or CPU-only if specified)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           PRAXISAI P900 LLAMA.CPP BUILDER                  ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

CUDA="ON"

while [[ $# -gt 0 ]]; do
    case $1 in
        --cpu-only)
            CUDA="OFF"
            shift
            ;;
        --clean)
            echo "Cleaning previous build..."
            rm -rf "$PROJECT_ROOT/llama.cpp/build"
            rm -rf "$PROJECT_ROOT/llama.cpp"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

cd "$PROJECT_ROOT"

echo "Configuration:"
echo "  CUDA Support: $CUDA"
echo ""

if [ ! -d "llama.cpp" ]; then
    echo "Cloning llama.cpp..."
    git clone https://github.com/ggml-org/llama.cpp
fi

echo "Installing dependencies..."
apt-get update -qq
apt-get install -y -qq pciutils build-essential cmake curl libcurl4-openssl-dev

echo ""
echo "Configuring build..."
if [ "$CUDA" = "ON" ]; then
    cmake llama.cpp -B llama.cpp/build \
        -DBUILD_SHARED_LIBS=OFF \
        -DGGML_CUDA=ON \
        -DCMAKE_CUDA_ARCHITECTURES="50;60;61;70;75;80;86;89;90"
else
    cmake llama.cpp -B llama.cpp/build \
        -DBUILD_SHARED_LIBS=OFF \
        -DGGML_CUDA=OFF
fi

echo ""
echo "Building binaries..."
cmake --build llama.cpp/build --config Release -j$(nproc) --clean-first --target llama-cli llama-mtmd-cli llama-server llama-gguf-split

echo ""
echo "Copying binaries..."
mkdir -p llama.cpp
cp llama.cpp/build/bin/llama-* llama.cpp/

echo ""
echo -e "\033[0;32m✓ Build complete!\033[0m"
echo "Binaries available in: $PROJECT_ROOT/llama.cpp/"
ls -la "$PROJECT_ROOT/llama.cpp/llama-"*
