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
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.brlaser
    pkgs.hll2390dw-cups
  ];
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "*:631" ];

  networking.firewall.allowedTCPPorts = [
    631    # cups
    11223  # jupyter
    8388   # shadowsocks
  ];

  services.jupyter.enable = true;
  services.jupyter.group = "jupyter";
  services.jupyter.kernels = {
    python3 = let
      env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
              Keras
              ipykernel
              matplotlib
              pandas
              pillow
              pip
              scikitlearn
              tensorflowWithCuda
            ]));
    in {
      displayName = "Python 3 for machine learning";
      language = "python";
      argv = [ "${env.interpreter}" "-m" "ipykernel_launcher" "-f" "{connection_file}" ];
    };
  };
  services.jupyter.password = "open('/etc/nixos/jupyter.pwd', 'r', encoding='utf8').read().strip()";
  services.jupyter.port = 11223;
  services.jupyter.ip = "10.10.1.11";

  services.shadowsocks.enable = true;
  services.shadowsocks.passwordFile = /etc/nixos/shadow.txt;

  services.transmission.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.dong = {
     isNormalUser = true;
     uid = 1011;
     extraGroups = [ "users" "jupyter" ];
     shell = pkgs.fish;
  };

}
