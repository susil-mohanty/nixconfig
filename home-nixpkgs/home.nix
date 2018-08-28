{ config, pkgs, ... }:

let updateDoom  = ''
  cd ~/.emacs.d
  nix-shell -p coreutils --run make
  '';
in
{
  # Emacs config
  # spacemacs config needs to be editable
  home.file.".spacemacs".source = "${config.home.homeDirectory}/.nixpkgs/dotfiles/emacs/spacemacs";

  home.packages = with pkgs; [
    chromium
    feh
    fira-code
    fira-code-symbols
    fira-mono
    okular
    pavucontrol
    rxvt_unicode_with-plugins
    sqlite
    tdesktop
    thefuck
    wirelesstools
    xclip
    wgetpaste
    ag
    ripgrep
    gmrun
    gucharmap
    jetbrains.idea-ultimate
    graphviz  # plantuml
    flameshot
    nmap
    urxvt_perls
    xsel  # for urxvt copy/paste
    gnome3.nautilus
    gthumb
    evince
    google-chrome
    haskellPackages.xmobar
    spotify
    goldendict
  ];

  # X
  home.file.".xprofile".source = ./dotfiles/x/xinitrc;
  home.file.".Xresources".source = ./dotfiles/x/xresources;
  home.file.".xmonad/xmonad.hs".source = ./dotfiles/xmonad/xmonad.hs;
  home.file.".xmobarrc".source = ./dotfiles/x/xmobarrc;
  home.file.".config/xresources_iosevka".source = ./dotfiles/x/xresources_iosevka;
  home.file.".config/base16-gruvbox-light-medium-256.Xresources".source = ./dotfiles/x/base16-gruvbox-light-medium-256.Xresources;

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
  home.file.".config/fish/functions/pcat.fish".source = ./dotfiles/fish/functions/pcat.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 36000;
    defaultCacheTtlSsh = 36000;
    enableSshSupport = true;
  };

  services.redshift.enable = true;
  services.redshift.latitude = "22";
  services.redshift.longitude = "114";

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.LESS = "-R";

  programs.home-manager.enable = true;

  programs.browserpass.enable = true;
  # programs.vim.enable = true;
  programs.neovim.enable = true;
  programs.neovim.withPython3 = true;
  programs.neovim.withPython = true;

  programs.emacs = {
    enable = true;

    package = pkgs.emacs.overrideAttrs (old: rec {
      wrapperPath = with pkgs.stdenv.lib; makeBinPath ([
        pkgs.ispell # needed?
        pkgs.plantuml
        pkgs.jre  # plantum
      ]);
    });

    extraPackages = epkgs: [
      # (epkgs.melpaPackages.mocha.overrideAttrs(oldAttrs: {
      #   patches = [ ./mocha-inspect.patch ];
      # }))
    ];
  };

  programs.git = {
    enable = true;
    userName = "sveitser";
    userEmail = "sveitser@gmail.com";
    signing.key = "0xB24B3D9AD2157945";
    signing.signByDefault = true;
    ignores = [ ".projectile" ];
  };

  # manual.manpages.enable = false;

}
