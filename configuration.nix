{ config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];
   
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Display manager
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = true;
  };
  services.xserver.windowManager.i3.enable = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS
  boot.initrd.luks.devices."luks-6dd0b6ad-da7d-44da-8bf6-fb20b3be1486".device = "/dev/disk/by-uuid/6dd0b6ad-da7d-44da-8bf6-fb20b3be1486";

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Users
  users.users.noy = {
    isNormalUser = true;
    extraGroups  = [ "networkmanager" "wheel"  "docker"];
  };

  # Unfree software
  nixpkgs.config.allowUnfree = true;

  # Base Packages
  environment.systemPackages = with pkgs; [
    dconf
    git
  ];

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      iptables = true;
      "log-driver" = "journald";
    };
  };

  # Security
  security.pam.services.i3lock = { enable = true; startSession = true; };
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.extraCommands = ''
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT
  '';
  security.apparmor.enable = true;
  security.audit.enable = true;
  services.fail2ban.enable = true;
  services.osquery.enable = true;

  # Maintenance
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-25.05";
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 14d";
  nix.package = pkgs.nix;

  system.stateVersion = "25.05";
}
