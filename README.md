### Installation

```bash
cd /etc/nixos
git init
git remote add origin git@gitlab.com:sveitser/nixconfig.git
git pull origin master
ln -s /etc/nixos/home-nixpkgs ~/.nixconfig
nix-env -i home-manager
home-manager switch
```
