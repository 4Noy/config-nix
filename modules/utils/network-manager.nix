{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  # todo: system-level service activation required
}
