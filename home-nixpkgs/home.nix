{ config, pkgs, ... }:

let updateDoom = ''
    .emacs.d/bin/doom -y re
  '';
  fontsize = pkgs.writeShellScriptBin "fontsize" ./bin/fontsize;
  org-git-sync = pkgs.writeShellScriptBin "org-git-sync" ./bin/org-git-sync;
  git-sync = pkgs.writeShellScriptBin "git-sync" ./bin/git-sync;
  clean-nix-store = pkgs.writeShellScriptBin "clean-nix-store" ./bin/clean-nix-store;
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

  home.packages = with pkgs; [
    lorri
    aspell
    aspellDicts.en
    calibre
    chromium
    clean-nix-store
    discord
    dropbox-cli
    evince
    exa                     # ls
    fd                      # find
    feh
    fontsize
    git-sync
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
    pulseeffects
    ripgrep
    rxvt_unicode_with-plugins
    spotify
    tdesktop
    thefuck
    tig
    urxvt_perls
    vlc
    vscode
    wgetpaste
    wirelesstools
    wmctrl
    wmname
    xclip
    xsel                    # for urxvt copy/paste
  ];

  # X
  home.file.".profile".source = ./dotfiles/x/profile;
  home.file.".Xresources".source = ./dotfiles/x/xresources;
  home.file.".xmobarrc".source = ./dotfiles/x/xmobarrc;
  home.file.".config/colortheme.Xresources".source = ./dotfiles/x/base16-snazzy-dark.Xresources;

  home.file.".config/rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;

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
  home.file."bin/org-capture".source = ./doom-emacs/bin/org-capture;
  home.file.".local/share/applications/emacs-capture.desktop".source = ./dotfiles/emacs/emacs-capture.desktop;

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

  home.file.".config/fish/functions/ipy.fish".source = ./dotfiles/fish/functions/ipy.fish;
  home.file.".config/fish/functions/py.fish".source = ./dotfiles/fish/functions/py.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/functions/fish_user_key_bindings.fish".source = ./dotfiles/fish/functions/fish_user_key_bindings.fish;
  home.file.".config/fish/functions/fish_greeting.fish".source = ./dotfiles/fish/functions/fish_greeting.fish;
  home.file.".config/fish/functions/ed.fish".source = ./dotfiles/fish/functions/ed.fish;
  home.file.".config/fish/functions/gcl.fish".source = ./dotfiles/fish/functions/gcl.fish;
  home.file.".config/fish/functions/ns-rev.fish".source = ./dotfiles/fish/functions/ns-rev.fish;
  home.file.".config/fish/functions/clean-docker.fish".source = ./dotfiles/fish/functions/clean-docker.fish;

  # lorri
  home.file.".direnvrc".text = ''
    use_nix() {
      echo "direnv: using lorri"
      eval "$(lorri direnv)"
      eval "$shellHook"
      local service="lorri@$(systemd-escape $(pwd))"
      systemctl --user start $service
      echo "Started systemd service $service"
    }
  '';
  systemd.user.services."lorri@" = {
    Unit = {
      ConditionPathExists = "%I";
      ConditionUser = "!@system";
      Description = "Lorri watch";
    };
    Service = {
      Environment = [
        "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
        "TZ=Asia/Hong_Kong"
        "TZDIR=${pkgs.tzdata}/share/zoneinfo"
        "PATH=/home/lulu/bin:/run/wrappers/bin:/home/lulu/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/etc/profiles/per-user/lulu/bin"
      ];
      ExecStart = "${pkgs.lorri}/bin/lorri -v watch";
      PrivateTmp = "true";
      ProtectSystem = "full";
      Restart = "on-failure";
      WorkingDirectory = "%I";
    };
  };


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
  programs.rofi.enable = true;
  programs.browserpass.enable = true;
  programs.emacs = {
    enable = true;

    package = (pkgs.emacs.override {
      srcRepo = true;
      # withXwidgets = true;
    }).overrideAttrs (old: rec {

      version = "27.0";
      versionModifier = "-dev";
      name = "emacs-${version}${versionModifier}";

      wrapperPath = with pkgs; stdenv.lib.makeBinPath ([
        gcc        # to compile emacsql
        plantuml
        jre        # for plantuml
        wordnet
        languagetool
        pandoc     # markdown preview
      ]);

      src = pkgs.fetchFromGitHub {
        owner = "emacs-mirror";
        repo = "emacs";
        rev = "56a3e4a5d366a8453608d9a604ebd5ddb4e52245";
        sha256 = "09xjq0s7hgw3l2y50kphq5pjzzngwv1d3x7gfarhxbfc9zw9j7s9";
      };

      # ./clean.env patch fails, stuff still works?
      patches = [ (builtins.elemAt old.patches 1)];

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
