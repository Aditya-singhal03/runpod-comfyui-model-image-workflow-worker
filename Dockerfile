# Dockerfile for Custom "Lilly" ComfyUI Worker with FLUX & ControlNet

# 1. Start from the official RunPod base image.
# This provides all necessary tools like comfy-node-install and comfy model download.
# Replace <version> with the latest stable tag (e.g., 5.1.0)
FROM runpod/worker-comfyui:5.1.0-base

# 2. Install all the Custom Nodes required by your workflow.
# We list them all in a single RUN command for efficiency.
RUN comfy-node-install \
    rgthree-comfy \
    comfyui-kjnodes \
    comfyui_ultimatesdupscale \
    comfyui_essentials \
    comfy-mtb

# 3. Download all the models your workflow needs.
# The --filename MUST EXACTLY MATCH the name used in your workflow JSON.
# IMPORTANT: You must find the real download URLs for these models.

# --- Checkpoints ---
# The filename creates the necessary subdirectories.
RUN comfy model download --url https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors?download=true --relative-path models/checkpoints --filename "FLUX1/flux1-dev.sft"

# --- LoRAs ---
RUN comfy model download --url https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true --relative-path models/loras --filename "lily-ai-avatar.safetensors"
RUN comfy model download --url https://civitai.com/api/download/models/993999?type=Model&format=SafeTensor --relative-path models/loras --filename "amateur-photography-forcu.safetensors"
RUN comfy model download --url https://civitai.com/api/download/models/1026423?type=Model&format=SafeTensor --relative-path models/loras --filename "another_amateur_photography.safetensors"
RUN comfy model download --url https://civitai.com/api/download/models/810340?type=Model&format=SafeTensor --relative-path models/loras --filename "boreal.safetensors"

# --- ControlNet ---
# The filename here also creates the required subdirectories.
RUN comfy model download --url https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors?download=true --relative-path models/controlnet --filename "FLUX.1/InstantX-FLUX1-Dev-Union/diffusion_pytorch_model.safetensors"

# --- Upscale Models ---
RUN comfy model download --url https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true --relative-path models/upscale_models --filename "4x-ClearRealityV1.pth"

# 4. Copy your static input image file into the image.
# This makes it available for the "Load Image" node.
COPY input/ /comfyui/input/