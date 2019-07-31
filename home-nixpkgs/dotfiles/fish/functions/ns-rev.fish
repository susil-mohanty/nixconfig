function ns-rev
    nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/$argv[1].tar.gz $argv[2..-1]
end
