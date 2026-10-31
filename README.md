# aoc-pod-image

A ready-made RunPod image so pods start with every tool already installed.

Image: `ghcr.io/ayushopchauhan/aoc-pod-image:latest` (also tagged by build date).

What's inside:
* Base: `runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404` (PyTorch 2.8, CUDA 12.8, SSH and Jupyter through the base `/start.sh`)
* ffmpeg, fonts, Node 22
* HyperFrames 0.8.111 and Playwright 1.49 Chromium at `/ms-playwright`
* ComfyUI v0.42.1 at `/opt/ComfyUI` with WanVideoWrapper, KJNodes, VideoHelperSuite, MelBandRoFormer, Frame Interpolation and GGUF

No model weights and no keys. Models go in `/workspace/models` (or `/runpod-volume/models`); run `/opt/start-comfy.sh` to link them and start ComfyUI on port 8188.

Rebuild: push to `main` or run the workflow by hand. GitHub Actions builds it and pushes to GHCR.
