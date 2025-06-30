{ config, lib, pkgs, ... }:

let
  root = ./.;

  args = { inherit root config lib pkgs; };

  apps     = [
    "alacritty"
    "firefox"
    "git"
    "kubernetes"
    "neovim"
    "spotify"
  ];

  wms      = [
    "i3"
  ];

  utils    = [
    "bluetooth"
    "dunst"
    "network-manager"
    "picom"
    "rofi"
  ];

  security = [
    "ssh"
  ];

  importMod = category: name:
    import (root + "/modules/${category}/${name}.nix") args;

  appImports     = lib.map (name: importMod "app" name)     apps;
  wmImports      = lib.map (name: importMod "wm"  name)     wms;
  utilImports    = lib.map (name: importMod "utils" name)   utils;
  secImports     = lib.map (name: importMod "security" name) security;

  loadedModules = lib.concatLists [ appImports wmImports utilImports secImports ];
in
{
  pkgs.config.allowUnfree = true;

  imports = loadedModules;
  home.username      = "noy";
  home.homeDirectory = "/home/noy";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  # Services user
  services.gpg-agent.enable = true;

  # User packages
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    tokyo-night-gtk

    ## Fonts
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
  ];

  ## X11 Keyboard layout
  xsession.enable = true;

  home.sessionVariables = {
        # None for now
  };

  ## Timezone and locals
  home.sessionVariables = {
    TZ = "Europe/Paris";
    LANG = "en_US.UTF-8";
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  
  # Wallpapers
  home.file.".config/wallpapers/lockscreen.png".source = ./files/wallpapers/lockscreen.png;
  home.file.".config/wallpapers/wallpaper.jpg".source = ./files/wallpapers/wallpaper.jpg;
}
