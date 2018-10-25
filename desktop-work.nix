{ config, pkgs, ... }:

{
  # Use local nixpkgs checkout
  # The first time, might have to run:
  #   nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixos-config=/etc/nixos/configuration.nix switch
  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
  nix.autoOptimiseStore = true;

  imports =
    [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
     ./pc-common.nix
    ];

  # boot.blacklistedKernelModules = [ "rtl8192se" ];
  boot.initrd.kernelModules = [ "8812au" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.rtl8821au ];

  networking.hostName = "mas";
  networking.networkmanager.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  # environment.systemPackages = with pkgs; [
  #   linuxPackages.rtlwifi_new
  # ];

  users.extraUsers.lulu.extraGroups = [ "networkmanager" ];
}
