{ pkgs, ... }:

{
  # Emacs config
  home.file.".spacemacs".source = ./dotfiles/emacs/spacemacs;

  home.packages = with pkgs; [
    python3
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
    zotero
  ];

  # X
  home.file.".xprofile".source = ./dotfiles/x/xinitrc;

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

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.LESS = "-R";

  programs.home-manager.enable = true;

  programs.browserpass.enable = true;
  # programs.vim.enable = true;
  programs.neovim.enable = true;
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
  };

  manual.manpages.enable = false;

}
