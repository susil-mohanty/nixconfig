{ config, pkgs, ... }:

let updateDoom = ''
    .emacs.d/bin/doom -y re
  '';
  fontsize = pkgs.writeShellScriptBin "fontsize" ./bin/fontsize;
  org-git-sync = pkgs.writeShellScriptBin "org-git-sync" ./bin/org-git-sync;
  git-sync = pkgs.writeShellScriptBin "git-sync" ./bin/git-sync;
in
{

  imports = [
    ./git.nix
  ];

  pam.sessionVariables = {
    XDG_RUNTIME_DIR = "/run/user/$(id -u)";
    BROWSER = "firefox";
  };
  home.sessionVariables.EDITOR = "emacsclient -c -s /tmp/emacs$(id -u)/server";
  home.sessionVariables.LESS = "-R";
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

  home.keyboard.variant = "colemak";

  home.packages = with pkgs; [
    lorri
    ag
    chromium
    discord
    dropbox-cli
    evince
    exa                     # ls
    fd                      # find
    feh
    fontsize
    git-sync
    gmrun
    gnome3.nautilus
    gnome3.dconf
    goldendict
    google-chrome
    graphviz                # for plantuml
    gthumb
    haskellPackages.xmobar
    jetbrains.idea-ultimate
    libnotify
    mosh
    ncdu
    nmap
    org-git-sync
    pavucontrol
    ripgrep
    rxvt_unicode_with-plugins
    spotify
    tdesktop
    texstudio
    thefuck
    urxvt_perls
    vlc
    weechat
    wgetpaste
    wirelesstools
    xclip
    xsel                    # for urxvt copy/paste
  ];

  # X
  home.file.".profile".source = ./dotfiles/x/profile;
  home.file.".Xresources".source = ./dotfiles/x/xresources;
  home.file.".xmobarrc".source = ./dotfiles/x/xmobarrc;
  home.file.".config/colortheme.Xresources".source = ./dotfiles/x/base16-snazzy-dark.Xresources;

  # editors
  home.file.".config/nvim/init.vim".source = ./dotfiles/vim/init.vim;
  home.file.".config/doom/init.el" = {
    source = ./dotfiles/emacs/doom/init.el;
    onChange = updateDoom;
  };
  home.file.".config/doom/packages.el" = {
    source = ./dotfiles/emacs/doom/packages.el;
    onChange = updateDoom;
  };
  home.file.".config/doom/config.el".source = ./dotfiles/emacs/doom/config.el;

  home.file.".config/doom/local/jest.el".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/orther/doom-emacs-private/7abc51ab8f31dd10bbd2ced495297bf2c6be91bb/local/jest.el";
    sha256 = "14f7gj1495wp7i855pa87257wwbdqchh8429qdhsjhv38smypm76";
  };

  # doom-emacs installs packages into ~/.emacs.d so we symlink directly
  home.activation.linkDoom = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfT "${config.home.homeDirectory}/.config/nixpkgs/doom-emacs" $HOME/.emacs.d
  '';

  # XXX make fails because this is in the nix store.
  # home.file.".emacs.d" = {
  #   source = pkgs.fetchFromGitHub {
  #     owner = "hlissner";
  #     repo = "doom-emacs";
  #     rev = "f9b06bd3a84e7c9a4de95bca905b92d9aaadc2fd";
  #     sha256 = "0bbky7naqng15zk055p7rmfp1541cz9rcz2mpk5kb0kvmmnzkkkc";
  #   };
  #   onChange = "cd ~/.emacs.d && nix-shell -p coreutils --run make";
  # };

  # Fish config
  home.file.".config/fish/functions/fish_prompt.fish".source = ./dotfiles/fish/functions/fish_prompt.fish;
  home.file.".config/fish/functions/fish_right_prompt.fish".source = ./dotfiles/fish/functions/fish_right_prompt.fish;
  home.file.".config/fish/functions/fish_title.fish".source = ./dotfiles/fish/functions/fish_title.fish;

  home.file.".config/fish/functions/nix-ipython.fish".source = ./dotfiles/fish/functions/nix-ipython.fish;
  home.file.".config/fish/functions/py.fish".source = ./dotfiles/fish/functions/py.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/functions/fish_user_key_bindings.fish".source = ./dotfiles/fish/functions/fish_user_key_bindings.fish;
  home.file.".config/fish/functions/fish_greeting.fish".source = ./dotfiles/fish/functions/fish_greeting.fish;
  home.file.".config/fish/functions/ed.fish".source = ./dotfiles/fish/functions/ed.fish;
  home.file.".config/fish/functions/gcl.fish".source = ./dotfiles/fish/functions/gcl.fish;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 36000;
    maxCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    maxCacheTtlSsh = 36000;
    enableSshSupport = true;
  };

  services.redshift.enable = true;
  services.redshift.latitude = "22";
  services.redshift.longitude = "114";
  services.redshift.brightness.night = "0.7";
  services.redshift.temperature.night = 2700;

  services.syncthing.enable = true;
  services.dunst.enable = true;         # notification daemon
  services.dunst.settings = {
    global = {
      geometry = "0x5-0+0";
      font = "Noto Sans 36"; }; };

  services.flameshot.enable = true;     # screeshots
  # services.udiskie = {  # broken as of 2019-03-07
  #   enable = true;
  #   notify = false;
  #   tray = "never";
  # };

  programs.home-manager.enable = true;
  programs.browserpass.enable = true;
  programs.emacs = {
    enable = true;

    package = pkgs.emacs.overrideAttrs (old: rec {
      wrapperPath = with pkgs; stdenv.lib.makeBinPath ([
        gcc        # to compile emacsql
        aspell
        aspellDicts.en
        plantuml
        jre        # for plantuml
        wordnet
        languagetool
        libvterm   # doesn't work yet
      ]);
      postFixup = ''
        wrapProgram $out/bin/emacs --prefix PATH : ${wrapperPath} --set SHELL ${pkgs.bash}/bin/bash
      '';
    });
  };

  programs.direnv.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = with pkgs; {
      l = "exa -lah";
      f = "rg --files";
      pcat = "${python3Packages.pygments}/bin/pygmentize";
      so = "pactl set-default-sink (pacmd list-sinks | awk \\\'/name:.*usb/{if (a != \"\") print a;} {a=$NF}\\\')";
      si = "pactl set-default-sink (pacmd list-sinks | awk \\\'/name:.*pci/{if (a != \"\") print a;} {a=$NF}\\\')";
    };
  };

  xsession.enable = true;
  xsession.windowManager.xmonad.enable = true;
  xsession.windowManager.xmonad.enableContribAndExtras = true;
  xsession.windowManager.xmonad.config = ./dotfiles/xmonad/xmonad.hs;

  services.compton.enable = true;
  # Prevent lags in urxvt.
  services.compton.extraOptions = ''
    xrender-sync = true;
    xrender-sync-fence = true;
  '';

  systemd.user.services.dropbox = {
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      PassEnvironment = "DISPLAY";
      Restart = "changed";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

 systemd.user.services.org-git-sync = {
    Service = {
      Type = "oneshot";
      Environment = "PATH=${pkgs.nix}/bin";
      ExecStart = "${org-git-sync}/bin/org-git-sync";
    };
  };
  systemd.user.timers.org-git-sync = {
    Timer = { OnCalendar = "*:14/15"; Persistent = true; };
    Install = { WantedBy = [ "timers.target" ]; };
  };

 systemd.user.services.git-sync = {
    Service = {
      Type = "oneshot";
      Environment = "PATH=${pkgs.nix}/bin";
      ExecStart = "${git-sync}/bin/git-sync";
    };
  };
  systemd.user.timers.git-sync = {
    Timer = { OnCalendar = "*:0/15"; Persistent = true; };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
