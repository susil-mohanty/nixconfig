{ config, pkgs, ... }:

let updateDoom = ''
    .emacs.d/bin/doom -y re
  '';
  fontsize = pkgs.writeShellScriptBin "fontsize" ''
    info="$(xrandr -q|grep -w 'connected')"
    pixels="$(echo $info|perl -pe 's|.*? (\d+)x.*|\1|')"
    length="$(echo $info|perl -pe 's|.*? (\d+)mm.*|\1|')"
    awk "BEGIN {print int(2.845e-3 * $pixels - 5.015e-3 * $length + 9.937 + 0.5)}"
  '';
in
{
  pam.sessionVariables = {
    XDG_RUNTIME_DIR = "/run/user/$(id -u)";
  };
  home.sessionVariables.EDITOR = "emacsclient -c";
  home.sessionVariables.LESS = "-R";
  home.keyboard.layout = "us -variant colemak";

  home.packages = with pkgs; [
    chromium
    discord
    evince
    exa                     # ls
    fd                      # find
    feh
    fontsize
    gmrun
    gnome3.nautilus
    goldendict
    google-chrome
    graphviz                # for plantuml
    gthumb
    haskellPackages.xmobar
    jetbrains.idea-ultimate
    libnotify
    ncdu
    nmap
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
  home.file.".doom.d/init.el" = {
    source = ./dotfiles/emacs/doom/init.el;
    onChange = updateDoom;
  };
  home.file.".doom.d/packages.el" = {
    source = ./dotfiles/emacs/doom/packages.el;
    onChange = updateDoom;
  };
  home.file.".doom.d/config.el".source = ./dotfiles/emacs/doom/config.el;
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
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/functions/fish_user_key_bindings.fish".source = ./dotfiles/fish/functions/fish_user_key_bindings.fish;
  home.file.".config/fish/functions/fish_greeting.fish".source = ./dotfiles/fish/functions/fish_greeting.fish;
  home.file.".config/fish/functions/ed.fish".source = ./dotfiles/fish/functions/ed.fish;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    enableSshSupport = true;
  };

  services.redshift.enable = true;
  services.redshift.latitude = "22";
  services.redshift.longitude = "114";
  services.syncthing.enable = true;
  services.dunst.enable = true;         # notification daemon
  services.dunst.settings = {
    global = {
      geometry = "0x5-0+0";
      font = "Noto Sans 36"; }; };

  services.flameshot.enable = true;     # screeshots
  services.udiskie = {
    enable = true;
    notify = false;
    tray = "never";
  };

  programs.home-manager.enable = true;
  programs.browserpass.enable = true;
  programs.emacs = {
    enable = true;

    package = pkgs.emacs.overrideAttrs (old: rec {
      wrapperPath = with pkgs.stdenv.lib; makeBinPath ([
        pkgs.ispell # needed?
        pkgs.plantuml
        pkgs.jre  # plantum
      ]);
      postFixup = ''
      wrapProgram $out/bin/emacs --set SHELL ${pkgs.bash}/bin/bash
      '';
    });
  };

  programs.git = {
    enable = true;
    userName = "sveitser";
    userEmail = "sveitser@gmail.com";
    signing.key = "0xB24B3D9AD2157945";
    signing.signByDefault = true;
    ignores = [ ".projectile" ];
    extraConfig = {
      pull = {
        rebase = true;
      };
    };
  };

  programs.direnv.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = with pkgs; {
      l = "exa -lah";
      pcat = "${python3Packages.pygments}/bin/pygmentize";
    };
  };

  xsession.enable = true;
  xsession.windowManager.xmonad.enable = true;
  xsession.windowManager.xmonad.enableContribAndExtras = true;
  xsession.windowManager.xmonad.config = ./dotfiles/xmonad/xmonad.hs;

  systemd.user.services.emacs-daemon = {
     Unit = {
       Description = "Emacs text editor";
       Documentation = "info:emacs man:emacs(1) https://gnu.org/software/emacs/";
       After = [ "hm-graphical-session.target" ];
     };

     Service = {
       Type = "simple";
       ExecStart = "${pkgs.stdenv.shell} -l -c 'exec %h/.nix-profile/bin/emacs --fg-daemon'";
       ExecStop = "%h/.nix-profile/bin/emacsclient --eval '(kill-emacs)'";
       Restart = "on-failure";
     };

     Install = {
       WantedBy = [ "default.target" ];
     };
  };

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
}
