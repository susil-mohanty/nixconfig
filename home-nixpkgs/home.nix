{ pkgs, ... }:

{
  # Emacs config
  home.file.".spacemacs".source = ./dotfiles/emacs/spacemacs;

  home.packages = with pkgs; [ ag ripgrep rxvt_unicode ];

  # Fish config
  home.file.".config/fish/functions/fish_prompt.fish".source = ./dotfiles/fish/functions/fish_prompt.fish;
  home.file.".config/fish/functions/fish_right_prompt.fish".source = ./dotfiles/fish/functions/fish_right_prompt.fish;
  home.file.".config/fish/functions/ipython.fish".source = ./dotfiles/fish/functions/ipython.fish;
  home.file.".config/fish/functions/pcat.fish".source = ./dotfiles/fish/functions/pcat.fish;
  home.file.".config/fish/functions/pless.fish".source = ./dotfiles/fish/functions/pless.fish;
  home.file.".config/fish/functions/wgetpaste.fish".source = ./dotfiles/fish/functions/wgetpaste.fish;
  home.file.".config/fish/config.fish".source = ./dotfiles/fish/config.fish;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
  
  home.sessionVariables.EDITOR = "emacs";
  home.sessionVariables.LESS = "-R";

  programs.browserpass.enable = true;
  # programs.vim.enable = true;
  programs.neovim.enable = true;
  programs.emacs = {
    enable = true;

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

}
