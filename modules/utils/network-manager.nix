{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [ networkmanager networkmanagerapplet ];
  # in configuration.nix: services.networking.networkmanager.enable = true;
}
