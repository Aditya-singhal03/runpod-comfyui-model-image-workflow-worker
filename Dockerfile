FROM runpod/worker-comfyui:5.1.0-base


ENV CIVITAI_TOKEN="5840b539d6d4aeb2827b98f550555710"
RUN echo $CIVITAI_TOKEN

# 3. Create all necessary model directories in a single layer for efficiency.
# The -p flag creates parent directories as needed (like 'controlnet').
# We quote the entire path to handle special characters and spaces correctly.
RUN mkdir -p \
    /comfyui/models/checkpoints/FLUX1 \
    /comfyui/models/loras \
    "/comfyui/models/controlnet/FLUX.1/InstantX-FLUX1-Dev-Union" \
    /comfyui/models/upscale_models \
    /comfyui/models/diffusion_models \
    /comfyui/models/vae \
    /comfyui/models/text_encoders

# 4. Download all the models your workflow needs using wget.

# --- Diffusion Model ---
RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/flux1-dev-fp8.safetensors?download=true" --relative-path models/diffusion_models --filename "flux1-dev.sft"
# --- VAE Model ---
RUN wget -O "/comfyui/models/vae/ae.safetensors" "https://huggingface.co/lovis93/testllm/resolve/ed9cf1af7465cebca4649157f118e331cf2a084f/ae.safetensors?download=true"

# --- Checkpoints ---
# RUN wget -O "/comfyui/models/checkpoints/FLUX1/flux1-dev.sft" "https://civitai.com/api/download/models/691639?type=Model&format=SafeTensor&size=full&fp=fp32&token=${CIVITAI_TOKEN}"
# RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/flux1-dev-fp8.safetensors?download=true" --relative-path models/checkpoints --filename "flux1-dev.sft"

# --- LoRAs ---
# RUN wget -O "/comfyui/models/loras/lily-ai-avatar.safetensors" "https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true"
RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true" --relative-path models/loras --filename "lily-ai-avatar.safetensors"

RUN wget -O "/comfyui/models/loras/amateur-photography-forcu.safetensors" "https://civitai.com/api/download/models/993999?token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/another_amateur_photography.safetensors" "https://civitai.com/api/download/models/1026423?token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/boreal.safetensors" "https://civitai.com/api/download/models/810340?token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/women_detailed_eye.safetensors" "https://civitai.com/api/download/models/1130726?type=Model&format=SafeTensor&token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/detailerd_hands.safetensors" "https://civitai.com/api/download/models/804967?type=Model&format=SafeTensor&token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/aeshtetic_pose.safetensors" "https://civitai.com/api/download/models/1050496?type=Model&format=SafeTensor&token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/aesthetics_flux.safetensors" "https://civitai.com/api/download/models/1050496?type=Model&format=SafeTensor&token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/flux_turbo_alpha.safetensors" "https://civitai.com/api/download/models/964759?type=Model&format=SafeTensor&token=${CIVITAI_TOKEN}"
RUN wget -O "/comfyui/models/loras/face_detailer_flux.safetensors" "https://civitai.com/api/download/models/1081450?type=Model&format=SafeTensor&token=${CIVITAI_TOKEN}"

# # --- ControlNet ---
RUN wget -O "/comfyui/models/controlnet/FLUX.1/InstantX-FLUX1-Dev-Union/diffusion_pytorch_model.safetensors" "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors?download=true"

# # --- Upscale Models ---
RUN wget -O "/comfyui/models/upscale_models/4x-ClearRealityV1.pth" "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true" 

# --- CLIP (Text Encoder) Models ---
RUN wget -O "/comfyui/models/text_encoders/google_t5-v1_1-xxl_encoderonly-fp8_e4m3fn.safetensors" "https://huggingface.co/Madespace/clip/resolve/main/google_t5-v1_1-xxl_encoderonly-fp8_e4m3fn.safetensors?download=true"
RUN wget -O "/comfyui/models/text_encoders/ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors" "https://huggingface.co/zer0int/CLIP-GmP-ViT-L-14/resolve/main/ViT-L-14-TEXT-detail-improved-hiT-GmP-TE-only-HF.safetensors?download=true"

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

RUN comfy-node-install \
    rgthree-comfy \
    comfyui-kjnodes \
    comfyui_ultimatesdupscale \
    comfyui_essentials \
    comfy-mtb \
    comfyui-advanced-controlnet \
    comfyui-detail-daemon \
    comfyui_tinyterranodes \
    was-node-suite-comfyui && \
    cd /comfyui/custom_nodes && \
    git clone https://github.com/spacepxl/ComfyUI-Image-Filters.git