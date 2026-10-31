#!/bin/bash
# Point ComfyUI at the model folder (network volume if attached, else /workspace/models) and start it on 8188.
M=/workspace/models
[ -d /runpod-volume/models ] && M=/runpod-volume/models
mkdir -p "$M"
for sub in diffusion_models text_encoders vae loras clip_vision checkpoints wav2vec2 upscale_models; do mkdir -p "$M/$sub"; done
rm -rf /opt/ComfyUI/models && ln -s "$M" /opt/ComfyUI/models
cd /opt/ComfyUI
while true; do python main.py --listen 0.0.0.0 --port 8188 "$@"; sleep 2; done
