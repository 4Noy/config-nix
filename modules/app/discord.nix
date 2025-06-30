{ config, pkgs, lib, root, ... }:

let
  discordPkg = pkgs.discord.override { withVencord = true; };
  wallpaperPath    = "${root}/files/wallpapers/discord-wallpaper.jpg";
  wallpaperDataUri = "data:image/jpeg;base64," + builtins.toBase64 (builtins.readFile wallpaperPath);
  dest       = ".config/Vencord/themes";
in {
  home.packages = [ discordPkg ];

  home.file."${dest}/discord-wallpaper.jpg".source = wallpaper;

  home.file."${dest}/default.theme.css".text = lib.concatStringsSep "\n" [
    "/**"
    " * @name ClearVision V7 for BetterDiscord (with custom background)"
    " * @version 7.0.1"
    " */"
    "@import url(\"https://clearvision.github.io/ClearVision-v7/main.css\");"
    "@import url(\"https://clearvision.github.io/ClearVision-v7/betterdiscord.css\");"
    ":root {"
    "  --main-color: #2780e6;"
    "  --hover-color: #1e63b3;"
    "  --success-color: #43b581;"
    "  --danger-color: #982929;"
    "  --online-color: #43b581;"
    "  --idle-color: #faa61a;"
    "  --dnd-color: #982929;"
    "  --streaming-color: #593695;"
    "  --offline-color: #808080;"
    "  --background-shading-percent: 100%;"
    "  --background-image: url(\"${wallpaperDataUri}\");"
    "  --background-position: center;"
    "  --background-size: cover;"
    "  --background-attachment: fixed;"
    "  --background-filter: saturate(calc(var(--saturation-factor,1)*1));"
    "  --user-popout-image: var(--background-image);"
    "  --user-popout-position: var(--background-position);"
    "  --user-popout-size: var(--background-size);"
    "  --user-popout-attachment: var(--background-attachment);"
    "  --user-popout-filter: var(--background-filter);"
    "  --user-modal-image: var(--background-image);"
    "  --user-modal-position: var(--background-position);"
    "  --user-modal-size: var(--background-size);"
    "  --user-modal-attachment: var(--background-attachment);"
    "  --user-modal-filter: var(--background-filter);"
    "  --home-icon: url(https://clearvision.github.io/icons/discord.svg);"
    "  --home-size: cover;"
    "  --main-font: \"gg sans\",\"Helvetica Neue\",Helvetica,Arial,sans-serif;"
    "  --code-font: Consolas,\"gg mono\",\"Liberation Mono\",Menlo,Courier,monospace;"
    "  --background-shading: rgba(0,0,0,0.4);"
    "  --card-shading: rgba(0,0,0,0.2);"
    "  --popout-shading: rgba(0,0,0,0.6);"
    "  --modal-shading: rgba(0,0,0,0.4);"
    "  --input-shading: rgba(255,255,255,0.05);"
    "  --normal-text: #d8d8db;"
    "  --muted-text: #aeaeb4;"
    "  --background-shading: rgba(0,0,0,0.6);"
    "  --card-shading: rgba(0,0,0,0.3);"
    "  --popout-shading: rgba(0,0,0,0.7);"
    "  --modal-shading: rgba(0,0,0,0.5);"
    "  --input-shading: rgba(255,255,255,0.05);"
    "  --normal-text: #fbfbfb;"
    "  --muted-text: #94949c;"
    "  --background-shading: rgba(0,0,0,0.8);"
    "  --card-shading: rgba(0,0,0,0.4);"
    "  --popout-shading: rgba(0,0,0,0.8);"
    "  --modal-shading: rgba(0,0,0,0.6);"
    "  --input-shading: rgba(255,255,255,0.05);"
    "  --normal-text: #dcdcde;"
    "  --muted-text: #86868e;"
    "}"
  ];
}
