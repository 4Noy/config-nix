{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    helm
    kind
    k9s
  ];

  programs.k9s.enable = true;
}
