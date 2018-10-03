# (Almost) reproducible nix config

## Installation

```bash
cd /etc/nixos
sudo chown -R $USER .
git init
git remote add origin git@gitlab.com:sveitser/nixconfig.git
git pull origin master
# To save time, copy nixpkgs repo to /etc/nixos/nixpkgs from somewhere close.
git submodules init

ln -s /etc/nixos/home-nixpkgs ~/.nixpkgs
ln -s /etc/nixos/nixpkgs ~/nixpkgs

mv configuration.nix{,.bkp}
ln -s your-config.nix configuration.nix

# we won't be using channels
rm -r ~/.nix-defexpr/*
ln -s /etc/nixos/nixpkgs ~/.nix-defexpr

sudo nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixos-config=/etc/nixos/configuration.nix switch

nix-shell ~/.nixpkgs/home-manager -A install
home-manager switch

# reboot at this point, good luck
```

## Todo
- [ ] Deterministic doom emacs setup.

## Credits

Inspired by and borrowed from https://github.com/adisbladis/nixconfig.
