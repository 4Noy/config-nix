{ root, config, pkgs, lib, ... }:

let
  discordPkg = pkgs.discord.override { withVencord = true; };
  plantImg = "${root}/files/wallpapers/discord-wallpaper.jpg";
in {
  home.packages = [
    discordPkg
  ];

  home.file.".config/Vencord/themes/plant-themed.jpg".source = plantImg;

  xdg.configFile."Vencord/themes/tokyo-night-plants.theme.css".text = lib.concatStringsSep "\n" [
    "@import url(\"https://raw.githubusercontent.com/Dyzean/Tokyo-Night/main/themes/tokyo-night.theme.css\");"
    ""
    "body {"
    "  background-image: url(\"file://${config.home.homeDirectory}/.config/Vencord/themes/plant-themed.jpg\");"
    "  background-size: cover;"
    "  background-position: center;"
    "  opacity: 0.85;"
    "}"
  ];
}
