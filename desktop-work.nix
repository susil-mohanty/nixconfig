{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
     ./pc-common.nix
    ];

  boot.extraModulePackages = [
     pkgs.linuxPackages.rtl8821au  # USB wifi
  ];

  networking.hostName = "mas";
  networking.networkmanager.enable = true;
  users.extraUsers.lulu.extraGroups = [ "networkmanager" ];

  services.xserver.extraConfig = ''
    Section "Device"
      Identifier  "Intel Graphics"
      Driver      "intel"
      Option      "TearFree" "true"
    EndSection
  '';

  powerManagement.cpuFreqGovernor = "performance";

}
