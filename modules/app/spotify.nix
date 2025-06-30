{ config, pkgs, lib, ... }:

let
  mediaBindings = lib.concatStringsSep "\n" [
    "\"playerctl play-pause\" XF86AudioPlay"
    "\"playerctl next\"       XF86AudioNext"
    "\"playerctl previous\"   XF86AudioPrev"
  ];
in {
  home.packages = with pkgs; [
    spotify
    playerctl
    xbindkeys
  ];

  # Configure xbindkeys with media key bindings
  home.file.".xbindkeysrc".text = mediaBindings;

  # Create portable autostart entry following XDG spec
  home.file.".config/autostart/xbindkeys.desktop".text = lib.concatStringsSep "\n" [
    "[Desktop Entry]"
    "Type=Application"
    "Name=XBindKeys"
    "Exec=${pkgs.xbindkeys}/bin/xbindkeys"
    "NoDisplay=true"
    "X-GNOME-Autostart-enabled=true"
  ];
}
