#!/bin/bash
# PraxisAI P900 - Reasoning CLI (4B) - Non-thinking mode
# Requires: llama.cpp compiled with llama-cli

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

export LLAMA_CACHE="$PROJECT_ROOT/models"

source "$PROJECT_ROOT/config/4b.env"

"$PROJECT_ROOT/llama.cpp/llama-cli" \
    -hf "$HF_REPO:$QUANT_TYPE" \
    --ctx-size "$CTX_SIZE" \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.00
