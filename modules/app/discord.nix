{ root, config, pkgs, lib, ... }:

let
  discordPkg = pkgs.discord.override { withVencord = true; };
  vencordDir = ".config/Vencord";
in {
  home.packages = [
    discordPkg
  ];

  home.file."${vencordDir}/themes/discord-wallpaper.jpg".source =
    "${root}/files/Vencord/themes/discord-wallpaper.jpg";

  home.file."${vencordDir}/themes/tokyo-plant.theme.css".source =
    "${root}/files/Vencord/themes/tokyo-plant.theme.css";
}
