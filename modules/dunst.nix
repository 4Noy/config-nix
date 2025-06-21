{ root, config, pkgs, ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Monospace 10";
        frame_width = 2;
        frame_color = "#565f89";
      };
      low = {
        timeout = 3;
        background = "#1a1b26";
        foreground = "#c0caf5";
      };
      normal = {
        timeout = 5;
        background = "#1a1b26";
        foreground = "#a9b1d6";
      };
      critical = {
        timeout = 0;
        background = "#f7768e";
        foreground = "#1a1b26";
      };
    };
  };
}
