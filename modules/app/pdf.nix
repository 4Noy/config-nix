{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    zathura
    zathura-ps
    xournalpp
  ];
}
