{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./pc-common.nix
    ];

  boot.initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/05807982-f62a-4e4b-9baf-45d62d253aa6";
        preLVM = true;
        keyFile = "/keyfile0.bin";
        allowDiscards = true;
      }
    ];

  networking.hostName = "trex";
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    linuxPackages.tp_smapi
  ];

  powerManagement.powertop.enable = true;
  # powerManagement.enable = true;
  #powerManagement.cpuFreqGovernor = "powersave";
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
  CPU_SCALING_GOVERNOR_ON_AC=performance
  CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      if grep -q closed /proc/acpi/button/lid/LID/state; then
        date >> /tmp/slock.log
        DISPLAY=":0" XAUTHORITY=/home/lulu/.Xauthority ${pkgs.slock}/bin/slock &>> /tmp/slock.log
      fi
    '';
  };
  sound.mediaKeys.enable = true;
  services.illum.enable = true;

  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;
  hardware.trackpoint.sensitivity = 200;

  services.xserver.dpi = 113; 
  services.xserver.synaptics.enable = true;

  users.extraUsers.lulu.extraGroups = [ "wheel" "networkmanager" "docker"];

}
