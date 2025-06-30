{ config, pkgs, lib, root, ... }:

let
  vh = "${config.home.homeDirectory}/.virtualenvs";
in {
  home.packages = with pkgs; [
    python310Full
    python310Packages.virtualenv
    python310Packages.virtualenvwrapper
    python310Packages.ipython
    direnv
  ];

  home.file.".config/pip/pip.conf".text = ''
    [global]
    cache-dir = ${config.home.homeDirectory}/.cache/pip
  '';

  home.file.".envrc".text = ''
    export WORKON_HOME="${vh}"
    export PROJECT_HOME="${config.home.homeDirectory}/Devel"
    export VIRTUALENVWRAPPER_PYTHON="${pkgs.python310Full}/bin/python3"
    source "${pkgs.python310Packages.virtualenvwrapper}/bin/virtualenvwrapper.sh"
  '';

  home.file.".profile".text = ''
    [[ -f "$HOME/.envrc" ]] && eval "$(direnv hook bash)"
  '';
}
