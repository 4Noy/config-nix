{ root, config, pkgs, ... }: {
  programs.docker.enable = true;
  # todo: needs user in docker group at system level
}
