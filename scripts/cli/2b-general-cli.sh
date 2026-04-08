#!/bin/bash
# PraxisAI P900 - General Tasks CLI (2B) - Non-thinking mode
# Requires: llama.cpp compiled with llama-cli

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

export LLAMA_CACHE="$PROJECT_ROOT/models"

source "$PROJECT_ROOT/config/2b.env"

"$PROJECT_ROOT/llama.cpp/llama-cli" \
    -hf "$HF_REPO:$QUANT_TYPE" \
    --ctx-size "$CTX_SIZE" \
    --temp 0.7 \
    --top-p 0.8 \
    --top-k 20 \
    --min-p 0.00
