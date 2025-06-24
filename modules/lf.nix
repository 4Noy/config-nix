{ root, config, pkgs, ... }: {
  programs.lf = {
    enable = true;
    settings = {
      preview = true;
      icons = true;
    };
  };
}
