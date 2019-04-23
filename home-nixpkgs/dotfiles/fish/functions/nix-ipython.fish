function nix-ipython
	nix-shell -p "(python3.withPackages (ps: with ps; [ ipython $argv ]))" --run ipython
end
