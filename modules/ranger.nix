{ root, config, pkgs, ... }: {
  programs.ranger = {
    enable = true;
    settings = {
      preview_images = true;
      use_preview_script = true;
    };
  };
}
