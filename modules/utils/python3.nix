{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    python310Full       # full stdlib + pip
    python310Packages.virtualenv
    python310Packages.ipython
  ];

  programs.virtualenvwrapper = {
    enable       = true;
    home         = "${config.home.homeDirectory}/.virtualenvs";
  };

  home.file.".config/pip/pip.conf".text = ''
    [global]
    cache-dir = ${config.home.homeDirectory}/.cache/pip
  '';
}
