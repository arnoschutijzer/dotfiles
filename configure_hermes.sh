#!/bin/zsh
# Register the local oMLX inference backend with Hermes Agent.
#
# oMLX (brew "omlx") serves MLX models over an OpenAI-compatible endpoint on
# 127.0.0.1:8000. This wires it in as a *selectable* Hermes provider without
# touching model.default — the cloud provider stays the default, oMLX is there
# to switch to (hermes model) when you want local, offline-capable inference.
#
# The pinned model is served from the standard Hugging Face cache (oMLX has
# hf_cache_enabled). Pull it with: hf download mlx-community/Qwen3.8-27B-4bit

# config.yaml is agent/security sensitive, so writes go through the hermes CLI,
# never a direct edit. `hermes config set` is idempotent, so this reruns safely.
if ! command -v hermes > /dev/null 2>&1; then
  echo "hermes not found, skipping oMLX provider registration (brew install hermes-agent)"
  return 0 2>/dev/null || exit 0
fi

hermes config set providers.omlx.name "oMLX"
hermes config set providers.omlx.api "http://127.0.0.1:8000/v1"
hermes config set providers.omlx.api_key "not-needed"
hermes config set providers.omlx.context_length 65536
hermes config set providers.omlx.default_model "mlx-community--Qwen3.8-27B-4bit"
hermes config set providers.omlx.discover_models true
echo "Registered oMLX provider with Hermes (select it with: hermes model)"
