{ config, pkgs, lib, ... }:

let
  mediaBindings = lib.concatStringsSep "\n" [
    # Play/Pause
    "\"playerctl play-pause\" XF86AudioPlay"
    # Next / Previous
    "\"playerctl next\"       XF86AudioNext"
    "\"playerctl previous\"   XF86AudioPrev"
  ];
in {
  home.packages = with pkgs; [
    spotify
    playerctl
    xbindkeys
  ];

  home.file.".xbindkeysrc".text = mediaBindings;

  home.sessionCommands = [
    "xbindkeys &"
  ];
}
