# Ready-made pod for AOC reels and AI clips: video render tools plus ComfyUI, no model weights.
FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

ENV DEBIAN_FRONTEND=noninteractive PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1 \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright HYPERFRAMES_SKIP_SKILLS=1

# System tools and fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
      ffmpeg curl wget git ca-certificates xz-utils unzip \
      fonts-dejavu fonts-liberation fonts-noto-core fonts-noto-color-emoji fontconfig \
    && rm -rf /var/lib/apt/lists/*

# Node 22, HyperFrames, and Playwright's Chromium with its system libraries
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g hyperframes@0.8.111 playwright@1.49.0 \
    && playwright install --with-deps chromium \
    && npx -y hyperframes@0.8.111 --version \
    && rm -rf /var/lib/apt/lists/* /root/.npm/_logs

# ComfyUI and the custom nodes we use, pinned to the torch the base image ships
ARG COMFYUI_VERSION=v0.42.1
RUN pip freeze | grep -iE '^(torch|torchvision|torchaudio)==' > /opt/torch-pins.txt \
    && git clone https://github.com/comfyanonymous/ComfyUI /opt/ComfyUI \
    && cd /opt/ComfyUI && git checkout ${COMFYUI_VERSION} \
    && pip install -c /opt/torch-pins.txt -r requirements.txt \
    && cd custom_nodes \
    && for r in kijai/ComfyUI-WanVideoWrapper kijai/ComfyUI-KJNodes Kosinkadink/ComfyUI-VideoHelperSuite \
                kijai/ComfyUI-MelBandRoFormer Fannovel16/ComfyUI-Frame-Interpolation city96/ComfyUI-GGUF; do \
         git clone --depth 1 https://github.com/$r; done \
    && for d in */; do [ -f "$d/requirements.txt" ] && pip install -c /opt/torch-pins.txt -r "$d/requirements.txt" || true; done \
    && pip install -c /opt/torch-pins.txt gguf onnx "transformers==4.57.3" "diffusers==0.35.2" \
    && python -c "import torch; print('torch', torch.__version__)"

COPY start-comfy.sh /opt/start-comfy.sh
RUN chmod +x /opt/start-comfy.sh
# CMD stays the base image's /start.sh, so SSH and Jupyter keep working.
