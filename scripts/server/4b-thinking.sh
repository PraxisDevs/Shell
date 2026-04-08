#!/bin/bash
# PraxisAI P900 - Thinking Mode Server (4B)
# Requires: llama.cpp compiled with llama-server

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

export LLAMA_CACHE="$PROJECT_ROOT/models"

source "$PROJECT_ROOT/config/4b.env"

"$PROJECT_ROOT/llama.cpp/llama-server" \
    -hf "$HF_REPO:$QUANT_TYPE" \
    --ctx-size "$CTX_SIZE" \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.00 \
    --alias "$ALIAS" \
    --port "$PORT" \
    --chat-template-kwargs '{"enable_thinking":true}'
