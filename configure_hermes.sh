#!/bin/zsh
# Register the local oMLX inference backend with Hermes Agent.
#
# oMLX (brew "omlx") serves MLX models over an OpenAI-compatible endpoint on
# 127.0.0.1:8000. This wires it in as a *selectable* Hermes provider without
# touching model.default — the cloud provider stays the default, oMLX is there
# to switch to (hermes model) when you want local, offline-capable inference.
#
# The model itself is not pinned here. oMLX has hf_cache_enabled, so it serves
# any MLX model already in the standard Hugging Face cache. Pull one on demand:
#   hf download mlx-community/Qwen3.8-27B-4bit
# then select it with `hermes model` (or set providers.omlx.default_model).

# config.yaml is agent/security sensitive, so writes go through the hermes CLI,
# never a direct edit. Nothing below depends on a running oMLX server — this
# only records how to reach it — so a machine without the model pulled still
# configures cleanly.
if ! command -v hermes > /dev/null 2>&1; then
  echo "hermes not found, skipping oMLX provider registration (brew install hermes-agent)"
  return 0 2>/dev/null || exit 0
fi

# `hermes config set` is idempotent: re-running rewrites the same keys. Guard on
# the api endpoint so a configured machine reruns make without noise.
if [ "$(hermes config get providers.omlx.api 2>/dev/null)" = "http://127.0.0.1:8000/v1" ]; then
  echo "oMLX provider already registered with Hermes"
else
  hermes config set providers.omlx.name "oMLX"
  hermes config set providers.omlx.api "http://127.0.0.1:8000/v1"
  hermes config set providers.omlx.api_key "not-needed"
  hermes config set providers.omlx.context_length 65536
  hermes config set providers.omlx.default_model "mlx-community--Qwen3.8-27B-4bit"
  hermes config set providers.omlx.discover_models true
  echo "Registered oMLX provider with Hermes (select it with: hermes model)"
fi
