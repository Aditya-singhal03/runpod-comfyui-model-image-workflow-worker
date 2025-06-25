# Dockerfile for Custom "Lilly" ComfyUI Worker with FLUX & ControlNet

# 1. Start from the official RunPod base image.
FROM runpod/worker-comfyui:5.1.0-base

# 2. Install all the Custom Nodes required by your workflow.
# RUN comfy-node-install \
#     rgthree-comfy \
#     comfyui-kjnodes \
#     comfyui_ultimatesdupscale \
#     comfyui_essentials \
#     comfy-mtb
# ARG HF_TOKEN
# --- THE FIX: Securely create a .env file with BOTH secrets ---
# This single RUN command creates the .env file that comfy-cli will automatically
# read to get credentials for both Hugging Face and Civitai.
# This requires HF_TOKEN and CIVITAI_TOKEN to be set as secrets in your GitHub repo.
# RUN --mount=type=secret,id=HF_TOKEN --mount=type=secret,id=CIVITAI_TOKEN \
#     echo "HUGGING_FACE_HUB_TOKEN=$(cat /run/secrets/HF_TOKEN)" >> /comfyui/.env && \
#     echo "CIVITAI_API_KEY=$(cat /run/secrets/CIVITAI_TOKEN)" >> /comfyui/.env

# 3. Download all the models your workflow needs using the comfy-cli.
# The tool will now be authenticated for both services via the .env file.
# We use the more explicit --output-path and --output-name flags.

# --- Checkpoints ---
RUN comfy model download --set-civitai-api-token "431954417d438ebfc2e084b259d42f73" --url "https://civitai.com/api/download/models/691639?type=Model&format=SafeTensor&size=full&fp=fp32" \
                         --relative-path models/checkpoints --filename "flux1-dev.sft"

# --- LoRAs ---
# RUN comfy model download --url "https://huggingface.co/singhal4896/lily_lora/resolve/main/lily-ai-avatar.safetensors?download=true" \
#                          --output-path models/loras --output-name "lily-ai-avatar.safetensors"

# # The comfy-cli will now use the API key from the .env file for these downloads.
# RUN comfy model download --url "https://civitai.com/api/download/models/993999" \
#                          --output-path models/loras --output-name "amateur-photography-forcu.safetensors"
# RUN comfy model download --url "https://civitai.com/api/download/models/1026423" \
#                          --output-path models/loras --output-name "another_amateur_photography.safetensors"
# RUN comfy model download --url "https://civitai.com/api/download/models/810340" \
#                          --output-path models/loras --output-name "boreal.safetensors"

# # --- ControlNet ---
# RUN comfy model download --url "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors?download=true" \
#                          --output-path models/controlnet/"FLUX.1/InstantX-FLUX1-Dev-Union" --output-name "diffusion_pytorch_model.safetensors"

# # --- Upscale Models ---
# RUN comfy model download --url "https://huggingface.co/skbhadra/ClearRealityV1/resolve/main/4x-ClearRealityV1.pth?download=true" \
#                          --output-path models/upscale_models --output-name "4x-ClearRealityV1.pth"

# # 4. Copy your static input image file into the image.
# COPY input/ /comfyui/input/