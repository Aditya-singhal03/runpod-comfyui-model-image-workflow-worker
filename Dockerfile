# Dockerfile for Custom "Lilly" ComfyUI Worker with FLUX & ControlNet

# 1. Start from the official RunPod base image.
FROM runpod/worker-comfyui:5.1.0-base

# 2. Install all the Custom Nodes required by your workflow.
RUN comfy-node-install \
    rgthree-comfy \
    comfyui-kjnodes \
    comfyui_ultimatesdupscale \
    comfyui_essentials \
    comfy-mtb

# --- THE FIX: Set the Hugging Face token as an environment variable first ---
# The secret 'HF_TOKEN' must be created in your GitHub repository settings.
# This ARG will receive the secret from the build command.
ARG HF_TOKEN
# This ENV makes the token available to all subsequent RUN commands.
ENV HUGGING_FACE_HUB_TOKEN=$HF_TOKEN

# 3. Download all the models your workflow needs.

# --- Checkpoints ---
# Now, we don't need to pass the token as a command-line argument.
# The comfy tool will automatically pick it up from the environment variable.
RUN comfy model download --url "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors?download=true" \
                         --relative-path models/checkpoints --filename "FLUX1/flux1-dev.sft"

# --- LoRAs ---
RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true" --relative-path models/loras --filename "lily-ai-avatar.safetensors"
RUN comfy model download --url "https://civitai.com/api/download/models/993999?type=Model&format=SafeTensor" --relative-path models/loras --filename "amateur-photography-forcu.safetensors"
RUN comfy model download --url "https://civitai.com/api/download/models/1026423?type=Model&format=SafeTensor" --relative-path models/loras --filename "another_amateur_photography.safetensors"
RUN comfy model download --url "https://civitai.com/api/download/models/810340?type=Model&format=SafeTensor" --relative-path models/loras --filename "boreal.safetensors"

# --- ControlNet ---
RUN comfy model download --url "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors?download=true" --relative-path models/controlnet --filename "FLUX.1/InstantX-FLUX1-Dev-Union/diffusion_pytorch_model.safetensors"

# --- Upscale Models ---
RUN comfy model download --url "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true" --relative-path models/upscale_models --filename "4x-ClearRealityV1.pth"

# 4. Copy your static input image file into the image.
COPY input/ /comfyui/input/