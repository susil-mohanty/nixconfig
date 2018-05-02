# Defined in /tmp/fish.DeFDHY/nix-ipython.fish @ line 2
function nix-ipython
	set -l packages ps.{$argv}
	nix-shell -p "(python3.withPackages (ps: [ ps.ipython ps.psutil $packages ]))" --run ipython
end
