# My (almost) reproducible nixos configuration

## "Features"
- Pinned checkout of [nixpkgs](https://github.com/nixos/nixpkgs)
- [home-manager](https://github.com/rycee/home-manager)
- [doom-emacs](https://github.com/hlissner/doom-emacs)
- `xmonad`
- `urxvt`

## Installation

Not extensively tested, probably with hickups.

```bash
cd /etc/nixos
sudo chown -R $USER .
git init
git remote add origin git@github.com:sveitser/nixconfig.git
git pull origin master
# To save time, copy nixpkgs repo to /etc/nixos/nixpkgs from somewhere close.
git submodules init

ln -s /etc/nixos/nixpkgs ~/nixpkgs
ln -s /etc/nixos/home-nixpkgs ~/.config/nixpkgs

mv configuration.nix{,.bkp}
ln -s this-machines-config.nix configuration.nix

# we won't be using channels
rm -r ~/.nix-defexpr/*
ln -s /etc/nixos/nixpkgs ~/.nix-defexpr

sudo nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixos-config=/etc/nixos/configuration.nix switch

nix-shell ~/.nixpkgs/home-manager -A install
home-manager switch

# Probably best to reboot at this point.
```

## Todo
- [ ] Deterministic doom emacs setup.
  + [x] doom-emacs submodule.
  + [ ] Emacs packages via nix.
- [x] Recompile xmonad when configuration is modified.

## Credits

Inspired by and borrowed from https://github.com/adisbladis/nixconfig.
