### Installation

```bash
cd /etc/nixos
git init
git remote add origin git@gitlab.com:sveitser/nixconfig.git
git pull origin master
ln -s /etc/nixos/home-nixpkgs ~/.nixpkgs

rm -r ~/.nix-defexpr/*
ln -s /etc/nixos/nixpkgs ~/.nix-defexpr

nix-shell ~/.nixpkgs/home-manager -A install
home-manager switch
```
