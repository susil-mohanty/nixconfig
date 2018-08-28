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

  boot.initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/49a4f5e8-db41-4b4b-800f-7df8ccaa22b3";
        preLVM = true;
        keyFile = "/keyfile0.bin";
        allowDiscards = true;
      }
    ];

  # boot.blacklistedKernelModules = [ "rtl8192se" ];
  boot.initrd.kernelModules = [ "8812au" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.rtl8821au ];

  networking.hostName = "mas";
  networking.networkmanager.enable = true;

  # environment.systemPackages = with pkgs; [
  #   linuxPackages.rtlwifi_new
  # ];

  users.extraUsers.lulu.extraGroups = [ "networkmanager" ];
}
