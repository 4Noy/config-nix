{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    pre-commit
  ];
}
