# Cisco Packet Tracer - installed from locally downloaded .deb
# Place the downloaded .deb at: ~/Downloads/CiscoPacketTracer_900_Ubuntu_64bit.deb
{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.ciscoPacketTracer9
  ];
}
