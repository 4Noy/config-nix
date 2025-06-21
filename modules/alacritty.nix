{ root, config, pkgs, ... }: {
  home.packages = with pkgs; [
    tree
    bat
    ripgrep
    fd
    fzf
    wget
    curl
    htop
    unzip
    killall
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 8; y = 1; };
        dynamic_padding = true;
        opacity = 0.95;
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 11.5;
      };

      colors = {
        primary = {
          background = "0x1a1b26";
          foreground = "0xc0caf5";
        };

        normal = {
          black   = "0x1a1b26";
          red     = "0xf7768e";
          green   = "0x9ece6a";
          yellow  = "0xe0af68";
          blue    = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan    = "0x7dcfff";
          white   = "0xc0caf5";
        };

        bright = {
          black   = "0x414868";
          red     = "0xff7a93";
          green   = "0xb9f27c";
          yellow  = "0xffd089";
          blue    = "0x7aa2f7";
          magenta = "0xd0a9f0";
          cyan    = "0xa4f9ef";
          white   = "0xf0f0f0";
        };

        cursor = {
          text = "0x1a1b26";
          cursor = "0xc0caf5";
        };

        selection = {
          text = "0x1a1b26";
          background = "0x7aa2f7";
        };
      };

      cursor.style = {
        shape = "Beam";
        blinking = "On";
      };
    };
  };
}
