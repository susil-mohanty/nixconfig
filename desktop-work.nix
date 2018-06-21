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
    ];

  nix.buildCores = 0;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    extraInitrd = /boot/initrd.keys.gz;
  };

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
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;
  # networking.firewall.allowedTCPPorts = [ 5901 ];

  # powerManagement.enable = false;
  powerManagement.cpuFreqGovernor = "performance";

  i18n = {
     consoleKeyMap = "colemak/en-latin9";
     defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Hong_Kong";

  environment.systemPackages = with pkgs; [
    # nmon # not available
    alsaUtils
    usbutils
    ag
    curl
    direnv
    firefox
    # fish
    fzf
    git
    htop
    pass
    tree
    plasma-nm
    vim
    wget
    gnupg
    wmname
    # rtlwifi_new
    linuxPackages.rtlwifi_new
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.slock.enable = true;

  # programs.fish.enable = true;

  services.openssh.enable = true;
  services.locate.enable = true;
  services.pcscd.enable = true;
  services.compton.enable = true;
  services.resolved.enable = true;

  # Gitlab CI
  # services.gitlab-runner.enable = true;
  # services.gitlab-runner.configFile = /home/lulu/.gitlab-runner/config.toml;

  fonts.fonts = with pkgs; [
    liberation_ttf
    fira-code
    dejavu_fonts
    iosevka
    noto-fonts
  ];

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.config = {
    flat-volumes = "no";
    resample-method = "src-sinc-best-quality";
    default-sample-format = "s24le";
    default-sample-rate = "96000";
  };

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  hardware.trackpoint.enable = true;

  services.xserver = {
     synaptics.enable = true;
     enable = true;
     xkbVariant = "colemak";

     displayManager.sddm.autoLogin.enable = true;
     displayManager.sddm.autoLogin.user = "lulu";
     displayManager.sddm.enable = true;

     desktopManager.xterm.enable = false;
     # desktopManager.plasma5.enable = true;

     windowManager.xmonad = {
       enable = true;
       enableContribAndExtras = true;
       extraPackages = haskellPackages: [
         haskellPackages.xmonad-contrib
         haskellPackages.xmonad-extras
         # haskellPackages.xmonad
       ];
     };
     windowManager.default = "xmonad";

     # windowManager.exwm = {
     #   enable = true;
     # };
     # windowManager.default = "exwm";
  };

  security.pam.loginLimits = [
  {
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "100000";
  } {
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "100000";
  }
  ];

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.lulu = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "networkmanager" "docker" ];
     shell = pkgs.fish;
  };

  # You should change this only after NixOS release notes say you should.
  system.nixos.stateVersion = "18.03"; # Did you read the comment?
  # system.stateVersion = "18.03"; # Did you read the comment?

}
