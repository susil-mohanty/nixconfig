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

  i18n = {
     consoleKeyMap = "colemak/en-latin9";
     defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Hong_Kong";

  environment.systemPackages = with pkgs; [
    ag
    alsaUtils
    curl
    direnv
    firefox
    fzf
    git
    gnupg
    htop
    nmon
    pass
    plasma-nm
    tree
    usbutils
    vim
    wget
    wmname
  ];

  programs.bash.enableCompletion = true;
  programs.slock.enable = true;

  programs.fish.enable = true;

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.openssh.enable = true;
  services.locate.enable = true;
  services.pcscd.enable = true;
  services.compton.enable = true;
  services.resolved.enable = true;

  fonts.fonts = with pkgs; [
    fira-code
    iosevka
    noto-fonts
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
     extraGroups = [ "audio" "wheel" "docker" ];
     shell = pkgs.fish;
  };

  # You should change this only after NixOS release notes say you should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
