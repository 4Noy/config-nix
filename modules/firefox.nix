{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    firejail
  ];
  programs.firefox = {
    enable  = true;
    package = pkgs.firefox;
  };
}
