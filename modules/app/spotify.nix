{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    spotify
    playerctl
  ];

  programs.xbindkeys.enable = true;
  home.file.".config/xbindkeys/spotify".text = ''
    "playerctl play-pause"  XF86AudioPlay
    "playerctl next"        XF86AudioNext
    "playerctl previous"    XF86AudioPrev
  '';
}
