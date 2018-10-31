{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
     ./pc-common.nix
    ];

  # USB wifi
  boot.extraModulePackages = [
     (pkgs.callPackage ./overlays/rtl8821au { kernel = pkgs.linuxPackages.kernel; })
  ];

  networking.hostName = "mas";
  networking.networkmanager.enable = true;
  users.extraUsers.lulu.extraGroups = [ "networkmanager" ];

  powerManagement.cpuFreqGovernor = "performance";

}
