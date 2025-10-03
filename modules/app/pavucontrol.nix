{ root, config, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.pavucontrol
  ];
}
