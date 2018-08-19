### Installation

```bash
cd /etc/nixos
sudo chown -R $USER .
git init
git remote add origin git@gitlab.com:sveitser/nixconfig.git
git pull origin master
# to save some time, copy nixpkgs to /etc/nixos/nixpkgs from somewhere close
git submodules init

ln -s /etc/nixos/home-nixpkgs ~/.nixpkgs
ln -s /etc/nixos/nixpkgs ~/nixpkgs

# we won't be using channels
rm -r ~/.nix-defexpr/*
ln -s /etc/nixos/nixpkgs ~/.nix-defexpr

sudo nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixos-config=/etc/nixos/configuration.nix switch

nix-shell ~/.nixpkgs/home-manager -A install
home-manager switch
```

### Todo
- [ ] Entire git config with home manager.
- [ ] Deterministic doom emacs setup.
- [ ] Pinyin input.
