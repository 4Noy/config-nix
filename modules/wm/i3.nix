{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    i3lock-color
    i3status
    feh
  ];
  #xsession.windowManager.i3.enable = true;
  home.file.".config/i3/config".source = "${root}/files/i3/config";
}
