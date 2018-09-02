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

  networking.firewall.allowedTCPPorts = [ 631 11223 ];

  services.jupyter.enable = true;
  services.jupyter.group = "jupyter";
  services.jupyter.kernels = {
    python3 = let
      env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
              ipykernel
              pandas
              pip
              scikitlearn
              tensorflowWithCuda
              Keras
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

}
