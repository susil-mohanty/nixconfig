{ config, pkgs, ... }:

with builtins;

{
  # Use local nixpkgs checkout
  # The first time, might have to run:
  #   nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixos-config=/etc/nixos/configuration.nix switch
  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
  ];
  nix.autoOptimiseStore = true;
  nix.buildCores = 0;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/".options = [ "noatime" "nodiratime" ];

  services.udev.extraRules = ''
    # set deadline scheduler for non-rotating disks
    # according to https://wiki.debian.org/SSDOptimization, deadline is preferred over noop
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"

    # UHK
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", MODE:="0666"
  '';

  fileSystems."/tmp" = {
    mountPoint = "/tmp";
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "relatime" ];
  };

  i18n = {
     consoleKeyMap = "colemak/colemak";
     defaultLocale = "en_US.UTF-8";
     # inputMethod.enabled = "fcitx";
     # inputMethod.fcitx.engines = [ pkgs.fcitx-engines.libpinyin ];
  };

  time.timeZone = "Asia/Hong_Kong";

  environment.systemPackages = with pkgs; [
    alsaUtils
    curl
    direnv
    firefox
    fzf
    git
    gnupg
    htop
    jq
    nix-index
    nmon
    pass
    ripgrep
    tmux
    tree
    usbutils
    vim
    wget
  ];

  programs.bash.enableCompletion = true;
  programs.fish.enable = true;
  programs.sedutil.enable = true;
  programs.slock.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.fstrim.enable = true;
  services.locate.enable = true;
  services.openssh.enable = true;
  services.pcscd.enable = true;
  services.resolved.enable = true;

  fonts.fonts = with pkgs; [
    arphic-ukai
    dejavu_fonts
    emacs-all-the-icons-fonts
    fira-code
    fira-code-symbols
    (nerdfonts.override { withFont = "Iosevka"; })
    noto-fonts-cjk
  ];

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.config = {
    flat-volumes = "no";
    resample-method = "src-sinc-best-quality";
    default-sample-format = "s24le";
    default-sample-rate = "96000";
  };

  services.xserver = {
     synaptics.enable = true;
     enable = true;
     xkbVariant = "colemak";

     displayManager.slim.enable = true;
     displayManager.slim.autoLogin = true;
     displayManager.slim.defaultUser = "lulu";

     desktopManager.xterm.enable = false;
     # desktopManager.plasma5.enable = true;

     # windowManager.xmonad = {
     #   enable = true;
     #   enableContribAndExtras = true;
     #   extraPackages = haskellPackages: [
     #     haskellPackages.xmonad-contrib
     #     haskellPackages.xmonad-extras
     #     # haskellPackages.xmonad
     #   ];
     # };
     # windowManager.default = "xmonad";

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

  networking.firewall.allowedTCPPorts = [
    8000  # web server
  ];

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.lulu = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "audio" "wheel" "docker" ];
     shell = pkgs.fish;
  };

  # You should change this only after NixOS release notes say you should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
