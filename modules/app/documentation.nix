{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    documentation
  ];
}
