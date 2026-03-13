# Waybar custom scripts — bluetooth, weather, GPU temp/util
{ config, lib, pkgs, ... }:
let
  scriptDeps = with pkgs; [
    # Add your Waybar script dependencies here
    bash
    curl # Assuming for weather script
    jq   # Likely needed for parsing JSON
    # Add other dependencies as needed
  ];
  
  scriptsDir = "${config.home.homeDirectory}/.config/waybar/scripts";
  
  # Instead of using builtins.readFile, we'll use the file path directly
  scriptFiles = {
    bluetooth_control = ./bluetooth-control;
    get_weather = ./get_weather.sh;
    gpu_temp = ./gpu-temp;
    gpu_util = ./gpu-util;
  };
  
in {
  home.packages = scriptDeps;
  
  # Generate individual file entries for each script
  home.file = lib.mkMerge ([
    # Add each script file individually
    (lib.mapAttrs' (name: path: {
      name = ".config/waybar/scripts/${name}";
      value = { 
        source = path;
        executable = true;
      };
    }) scriptFiles)
    
    # Add the directory marker
    { ".config/waybar/scripts/.keep".text = ""; }
  ]);
  

}