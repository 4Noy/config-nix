{ root, config, pkgs, ... }: {
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    settings = {
      "corner-radius"    = 10;
      shadow              = true;
      "shadow-radius"    = 12;
      "shadow-opacity"   = 0.4;
      "inactive-opacity" = 0.85;
      "active-opacity"   = 1.0;
      "blur-background"  = true;
      "blur-method"      = "dual_kawase";
      "blur-strength"    = 5;
    };
  };
}
