{ root, config, pkgs, ... }: {  
  programs.git = {
    enable    = true;
    lfs.enable = true;

    # New structure: settings.{ user = { name, email }, alias = { ... } }
    settings = {
      user = {
        name  = "Noy.";
        email = "";
      };

      # aliases moved under settings.alias
      alias = {
        a = "add";
        c = "commit";
        t = "tag";
        p = "push";
      };
    };
  };
}
