### Installation

```bash
git clone git@gitlab.com:sveitser/nixconfig.git /etc/nixos/home-nixpkgs
ln -s /etc/nixos/home-nixpkgs ~/.nixconfig
nix-env -i home-manager
home-manager switch
```
