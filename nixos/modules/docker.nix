{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  users.users.rahul = {
    isNormalUser = true;
    extraGroups = [ "docker"];
  };
}
