# Nix config

```sh
cd
nix-shell -p git -- run "git clone git@github.com:4Noy/config-nix.git"
mkdir .config
mv config-nix .config/home-manager
cd .config/home-manager
sudo cp configuration.nix /etc/nixos/configuration.nix
# CHANGE THE LUKS NAME
sudo nixos-rebuild switch
nix run .#homeConfigurations.noy.activationPackage
home-manager switch
```
