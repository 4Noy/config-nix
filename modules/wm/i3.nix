{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    i3lock-color
    i3status
    feh
  ];
  home.file.".config/i3/config".source = "${root}/files/i3/config";
  home.file."../../../../../bin/lock".source = "${root}/files/bin/lock";
}
