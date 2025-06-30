{ root, config, pkgs, ... }: {
  home.file.".config/rofi/themes/tokyo-night.rasi".source = "${root}/files/rofi/tokyo-night.rasi";
  programs.rofi = {
    enable = true;
    theme = "~/.config/rofi/themes/tokyo-night.rasi";
  };
}
