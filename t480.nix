{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  nix.buildCores = 0;
  nix.nixPath = [
    "/etc/nixos/nixpkgs"
    "nixpkgs=/etc/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  networking.extraHosts = ''
    10.10.1.2   nas
    10.10.1.10  desktop
  '';

  # fileSystems."/nas" = {
  #   device = "nas:/";
  #   fsType = "nfs4";
  #   options = ["rsize=8192,wsize=8192,timeo=14,intr,_netdev,bg"];
  #   # options = ["x-systemd.automount,noauto"];
  # };

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
        device = "/dev/disk/by-uuid/94f893ff-62d8-4aae-ac27-5f531768d624";
        preLVM = true;
        keyFile = "/keyfile0.bin";
        allowDiscards = true;
      }
    ];

  networking.hostName = "trex";
  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  i18n = {
     consoleKeyMap = "colemak/en-latin9";
     defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Hong_Kong";

  environment.systemPackages = with pkgs; [
    # nmon
    alsaUtils
    acpi
    ag
    direnv
    firefox
    # fish
    fzf
    git
    htop
    pass
    plasma-nm
    powertop
    tree
    tmux
    # neovim
    xorg.xbacklight
    gnupg
    #(import .vim.nix)
    wget
    usbutils
    haskellPackages.xmobar
    linuxPackages.tp_smapi
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.slock.enable = true;

  programs.fish.enable = true;

  services.openssh.enable = true;
  services.locate.enable = true;
  services.pcscd.enable = true;  # smart card

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

  powerManagement.powertop.enable = true;
  # powerManagement.enable = true;
  #powerManagement.cpuFreqGovernor = "powersave";
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
  CPU_SCALING_GOVERNOR_ON_AC=performance
  CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';
  # services.udev.extraRules = ''
  #   # set deadline scheduler for non-rotating disks
  #   # according to https://wiki.debian.org/SSDOptimization, deadline is preferred over noop
  #   ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
  # '';
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

  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  hardware.trackpoint.enable = true;
  hardware.trackpoint.emulateWheel = true;
  hardware.trackpoint.sensitivity = 200;

  services.xserver = {
     dpi = 113;  # makes everything huge :(
     synaptics.enable = true;
     enable = true;
     xkbVariant = "colemak";

     displayManager.sddm.autoLogin.enable = true;
     displayManager.sddm.autoLogin.user = "lulu";
     displayManager.sddm.enable = true;

     desktopManager.xterm.enable = false;

     # desktopManager.plasma5.enable = true;
     # desktopManager.default = "plasma5";

     windowManager.xmonad = {
       enable = true;
       enableContribAndExtras = true;
       extraPackages = haskellPackages: [
         haskellPackages.xmonad-contrib
         haskellPackages.xmonad-extras
       ];
     };
     windowManager.default = "xmonad";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.lulu = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "networkmanager" "docker"];
     shell = pkgs.fish;
   };

  # You should change this only after NixOS release notes say you should.
  system.nixos.stateVersion = "18.09"; # Did you read the comment?

  virtualisation.docker.enable = true;

}
