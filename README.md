### Installation

```bash
cd /etc/nixos
git init
git remote add origin git@gitlab.com:sveitser/nixconfig.git
git pull origin master
ln -s /etc/nixos/home-nixpkgs ~/.nixconfig

rm -r ~/.nix-defexpr/*
ln -s /etc/nixos/nixpkgs ~/.nix-defexpr

nix-env -i home-manager
home-manager switch
```
