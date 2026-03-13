# Generic NVIDIA driver configuration for hybrid Intel + NVIDIA laptops
# Hardware-specific values (PCI bus IDs) go in hosts/<hostname>/default.nix
{ config, lib, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # Enable Intel graphics drivers
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      intel-media-driver    # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    powerManagement = {
      enable = true;
      # finegrained = true;  # Disabled: conflicts with suspend on some hybrid laptops
    };

    # Use the stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # NVIDIA-specific variables for Hyprland
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "iHD";  # Use Intel's media driver for video acceleration
    GBM_BACKEND = "nvidia-drm";
    WLR_RENDERER = "vulkan";
  };

  # Create a convenient script to run applications with the NVIDIA GPU
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "prime-run" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];

  # NVIDIA suspend/resume fix for s2idle (modern standby)
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Save VRAM on suspend
    "nvidia.NVreg_EnableS0ixPowerManagement=1"        # Enable s2idle support
  ];

  # Keep NVIDIA driver loaded to prevent state loss
  hardware.nvidia.nvidiaPersistenced = true;
}
