"""Puts the Hunyuan3D-2 weights and the rembg model where hy3dgen looks (HY3DGEN_MODELS, U2NET_HOME). Skips anything already there.
On pods both point at the network volume, so this only downloads once. The image build runs it into /tmp to prove the models load."""
import os, pathlib
from huggingface_hub import snapshot_download
root = pathlib.Path(os.environ["HY3DGEN_MODELS"]) / "tencent/Hunyuan3D-2"
done = root / ".complete"
if not done.exists():
    snapshot_download("tencent/Hunyuan3D-2", local_dir=str(root),
                      allow_patterns=["config.json", "hunyuan3d-dit-v2-0/config.yaml", "hunyuan3d-dit-v2-0/model.fp16.safetensors",
                                      "hunyuan3d-delight-v2-0/*", "hunyuan3d-paint-v2-0/*"],
                      ignore_patterns=["*/unet/*.bin", "*/vae/*.bin", "*.ckpt"])   # the .bin and .ckpt copies have a safetensors twin
    done.touch()
from hy3dgen.rembg import BackgroundRemover
BackgroundRemover()   # downloads its model into U2NET_HOME on first use
print("weights ready in", root, flush=True)
