function py
    nix-shell -p "(python3.withPackages (ps: with ps; [ $argv ]))"
end
