{ config, lib, pkgs, ... }:

let
  root = ./.;

  modules = [
    "alacritty"
    "bluetooth"
        #"discord"
    "dunst"
    "firefox"
    "git"
        #"gpg"
    "i3"
    "kubernetes"
        #"lf" # "ranger"
    "neovim"
    "picom"
    "rofi"
    "ssh"
  ];
  loadedModules = builtins.map (name: import ("${root}/modules/${name}.nix") { inherit root config lib pkgs; }) modules;

in {
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
