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

  boot.kernelModules = [ "k10temp" "nct6775" ];

  networking.hostName = "lulus";

  powerManagement.cpuFreqGovernor = "performance";

  services.xserver.videoDrivers = [ "nvidia" ];  # Required for CUDA apps.
  services.xserver.wacom.enable = true;

  # Prevents most tearing.
  services.xserver.extraConfig = ''
    Section "Device"
        Identifier "Default nvidia Device"
        Driver	"nvidia"
        Option	"NoLogo"				"true"
        Option	"CoolBits"				"24"
        Option	"ForceFullCompositionPipeline"	"true"
    EndSection
  '';

  # services.printing.enable = true;
  # services.printing.drivers = [
  #   pkgs.gutenprint
  #   pkgs.brlaser
  #   pkgs.hll2390dw-cups
  # ];
  # services.printing.browsing = true;
  # services.printing.listenAddresses = [ "*:631" ];

  programs.mosh.enable = true;

  networking.firewall.allowedTCPPorts = [
    # 631    # cups
    11223  # jupyter
    8388   # shadowsocks
    9004   # transmission
  ];

  services.jupyter.enable = true;
  services.jupyter.group = "jupyter";
  services.jupyter.kernels = {
    python3 = let
      env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
              Keras
              ipykernel
              matplotlib
              # pandas # 2019 02 17: broken in nixkpgs
              pillow
              pip
              scikitlearn
              # tensorflowWithCuda # doesn't work with python3.7
            ]));
    in {
      displayName = "Python 3 for machine learning";
      language = "python";
      argv = [ "${env.interpreter}" "-m" "ipykernel_launcher" "-f" "{connection_file}" ];
    };
  };
  services.jupyter.password = "open('/etc/nixos/secrets/jupyter.pwd', 'r', encoding='utf8').read().strip()";
  services.jupyter.port = 11223;
  services.jupyter.ip = "10.10.1.11";

  services.shadowsocks.enable = true;
  services.shadowsocks.passwordFile = /etc/nixos/secrets/shadow.txt;
  services.shadowsocks.encryptionMethod = "aes-256-ctr";

  services.transmission.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.extraUsers.lulu.extraGroups = [ "transmission"  "vboxusers" ];

  users.extraUsers.dong = {
     isNormalUser = true;
     uid = 1011;
     extraGroups = [ "users" "jupyter" ];
  };

}
