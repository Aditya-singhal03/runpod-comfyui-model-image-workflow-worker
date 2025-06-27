FROM runpod/worker-comfyui:5.1.0-base

# 2. Install all the Custom Nodes required by your workflow.
RUN comfy-node-install \
    rgthree-comfy \
    comfyui-kjnodes \
    comfyui_ultimatesdupscale \
    comfyui_essentials \
    comfy-mtb

ENV CIVITAI_TOKEN="5840b539d6d4aeb2827b98f550555710"
RUN echo $CIVITAI_TOKEN


# 3. Create all necessary model directories in a single layer for efficiency.
# The -p flag creates parent directories as needed (like 'controlnet').
# We quote the entire path to handle special characters and spaces correctly.
RUN mkdir -p \
    /comfyui/models/checkpoints/FLUX1 \
    /comfyui/models/loras \
    "/comfyui/models/controlnet/FLUX.1/InstantX-FLUX1-Dev-Union" \
    /comfyui/models/upscale_models

# 4. Download all the models your workflow needs using wget.

# --- Checkpoints ---
# RUN wget -O "/comfyui/models/checkpoints/FLUX1/flux1-dev.sft" "https://civitai.com/api/download/models/691639?type=Model&format=SafeTensor&size=full&fp=fp32&token=${CIVITAI_TOKEN}"
RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/flux1-dev.safetensors?download=true" --relative-path models/checkpoints --filename "flux1-dev.sft"

# --- LoRAs ---
# RUN wget -O "/comfyui/models/loras/lily-ai-avatar.safetensors" "https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true"
RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true" --relative-path models/loras --filename "lily-ai-avatar.safetensors"

RUN wget -O "/comfyui/models/loras/amateur-photography-forcu.safetensors" "https://civitai.com/api/download/models/993999?token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/another_amateur_photography.safetensors" "https://civitai.com/api/download/models/1026423?token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/boreal.safetensors" "https://civitai.com/api/download/models/810340?token=${CIVITAI_TOKEN}"

# # --- ControlNet ---
RUN wget -O "/comfyui/models/controlnet/FLUX.1/InstantX-FLUX1-Dev-Union/diffusion_pytorch_model.safetensors" "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors?download=true"

# # --- Upscale Models ---
RUN wget -O "/comfyui/models/upscale_models/4x-ClearRealityV1.pth" "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true"

# # 5. Copy your static input image file into the image.
COPY input/ /comfyui/input/