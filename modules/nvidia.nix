# NVIDIA hybrid graphics — HP Victus (Intel + RTX 2050)
# Uses PRIME offload mode: Intel runs the desktop, NVIDIA only when explicitly used
{ config, pkgs, ... }:

{
  # OpenGL / VA-API
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver   # NVIDIA VAAPI bridge
      intel-media-driver    # Intel iHD VA-API driver (set via LIBVA_DRIVER_NAME=iHD)
      intel-vaapi-driver    # Intel i965 fallback
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings     = true;

    # Open kernel module — required for RTX 2050 (Turing+ only, kernel ≥ 5.18)
    open = true;

    # Power management — keeps GPU state across suspend
    powerManagement = {
      enable = true;
      # finegrained = true;  # Uncomment if you want NVIDIA to fully power off
                             # when idle — can cause issues on some laptops
    };

    # Keep NVIDIA driver loaded to prevent VRAM state loss on resume
    nvidiaPersistenced = true;

    # Force correct composition pipeline (prevents tearing on external displays)
    forceFullCompositionPipeline = true;

    # Driver version — stable is safest for RTX 2050
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME — offload mode: Intel = default, NVIDIA = on demand via prime-run
    prime = {
      offload = {
        enable          = true;
        enableOffloadCmd = true;
      };
      intelBusId  = "PCI:0:2:0";  # integrated GPU
      nvidiaBusId = "PCI:1:0:0";  # dedicated GPU
    };
  };

  # Session environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME       = "iHD";         # use Intel VA-API for video decode
    GBM_BACKEND             = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";           # fix cursor rendering on NVIDIA/Wayland
    WLR_RENDERER            = "vulkan";
  };

  # prime-run helper script
  # Usage: prime-run <app>   e.g. prime-run firefox
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "prime-run" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
}
