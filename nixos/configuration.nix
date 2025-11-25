# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  # Enable battery monitoring service with enhanced features
  services.battery-monitor = {
    enable = true;
    normalLevels = [ 30 20 15 ];  # Notification at these levels
    criticalLevel = 10;           # Continuous notifications below this level
    criticalIntervalSeconds = 1;  # Send notification every 1 second when critical
    hibernateLevel = 5;           # Hibernate at this level (set to null to disable)
    chargerNotifications = true;  # Enable notifications for charger connect/disconnect
  };
}
