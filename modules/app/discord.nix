{ config, pkgs, lib, root, ... }:

let
  discordPkg  = pkgs.discord.override { withVencord = true; };
  wallpaper   = "${root}/files/wallpapers/discord-wallpaper.jpg";
  themeDir    = ".config/Vencord/themes";
  themeName   = "default-nature-tokyo.theme.css";
  css = lib.concatStringsSep "\n" [
    "/**"
    " * @name SoftX with custom background"
    " * @version 2.0.0"
    " */"
    "@import url('https://discordstyles.github.io/SoftX/SoftX.css');"
    "@import url(\"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500&display=swap\");"
    ":root {"
    "  --background-image: url(\"./discord-wallpaper.jpg\");"
    "  --background-blur: 0px;"
    "  --accent: hsl(164 100% 45%);"
    "  --accent-text: hsl(0 0 0%);"
    "  --glow-intensity: 1;"
    "  --members-width: 280px;"
    "  --guilds-width: 95px;"
    "  --server-icon-size: 46;"
    "  --chat-avatar-size: 40px;"
    "  --opacity: 0.85;"
    "  --font: \"Inter\";"
    "  --rs-small-spacing: 2px;"
    "  --rs-medium-spacing: 4px;"
    "  --rs-large-spacing: 4px;"
    "  --rs-small-width: 1.5px;"
    "  --rs-medium-width: 2px;"
    "  --rs-large-width: 2px;"
    "  --rs-online-color: #43b581;"
    "  --rs-idle-color: #faa61a;"
    "  --rs-dnd-color: #f04747;"
    "  --rs-offline-color: #636b75;"
    "  --rs-streaming-color: #643da7;"
    "  --rs-invisible-color: #747f8d;"
    "  --rs-phone-color: var(--rs-online-color);"
    "  --rs-phone-visible: block;"
    "}"
  ];
in {
  home.packages = [ discordPkg ];

  home.file."${themeDir}/discord-wallpaper.jpg".source = wallpaper;

  home.file."${themeDir}/${themeName}".text = css;
}
