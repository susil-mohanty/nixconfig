function ipy
	nix-shell -p "(python3.withPackages (ps: with ps; [ ipython nixpkgs $argv ]))" --run ipython
end
