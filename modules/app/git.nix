{ root, config, pkgs, ... }: {  
  programs.git = {
    enable    = true;
    userName  = "Noy.";
    userEmail = "";
    lfs.enable = true;

    aliases = {
      a = "add";
      c = "commit";
      t = "tag";
      p = "push";
    };
  };
}
