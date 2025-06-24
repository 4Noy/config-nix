{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    blueman
  ];

  # todo: system-level activation needed:
  # services.bluetooth.enable = true;
}
