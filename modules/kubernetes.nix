{ root, config, pkgs, ... }: {
  programs.k9s.enable = true;

  home.packages = with pkgs; [
    kubectl
    helm
    kind
    k9s
  ];
}
