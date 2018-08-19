{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./pc-common.nix 
      ./vpn/pia-system.nix
    ];

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/3d9e9f30-3f6e-4737-a284-5dca95c23bab";
    fsType = "ext4";
  };

  boot.initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/c3d7cbf3-5ddd-42f1-ac03-68dccb16d18a";
        preLVM = true;
        keyFile = "/keyfile0.bin";
        allowDiscards = true;
      }
    ];

  networking.hostName = "lulus";

  powerManagement.cpuFreqGovernor = "performance";

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.brlaser ];
  
}
