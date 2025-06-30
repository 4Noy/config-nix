{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    blueman
  ];
  # in configuration.nix: services.bluetooth.enable = true;
}
