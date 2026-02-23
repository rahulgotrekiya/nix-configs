# Configuration for NVIDIA drivers on laptop with hybrid graphics
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
      finegrained = true;
    };
    
    # Prime configuration for hybrid Intel + NVIDIA graphics
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # integrated
      intelBusId = "PCI:0:2:0"; 
      # dedicated
      nvidiaBusId = "PCI:1:0:0";
    };
    
    # Use the NixOS-provided Xorg configuration
    forceFullCompositionPipeline = true;
    
    # Use the stable driver package appropriate for RTX 2050
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # For Hyprland users with hybrid graphics
  environment.sessionVariables = {
    # For Wayland compatibility
    NIXOS_OZONE_WL = "1";
    # NVIDIA-specific variables for Hyprland 
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "iHD";  # Use Intel's media driver for video acceleration
    # For Wayland/Hyprland with NVIDIA
    GBM_BACKEND = "nvidia-drm";
    WLR_RENDERER = "vulkan";
  };

  # Create a convenient script to run applications with the NVIDIA GPU
  environment.systemPackages = with pkgs; [
    # Add a convenient script to run applications with the NVIDIA GPU
    (writeShellScriptBin "prime-run" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];

  # Add a boot parameter to enable proper power management
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
