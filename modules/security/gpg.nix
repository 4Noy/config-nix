{ root, config, pkgs, ... }: {
  programs.gpg = {
    enable = true;
    package = pkgs.gnupg;
    homedir = "${config.home.homeDirectory}/.gnupg";
    settings = {
      "use-agent" = "";
      "cipher-algo" = "AES256";
      "digest-algo" = "SHA512";
      "cert-digest-algo" = "SHA512";
      "no-emit-version" = "";
      "no-comments" = "";
      "disable-cipher-algo" = "3DES";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableScDaemon = true;
    defaultCacheTtl = 600;
    maxCacheTtl = 3600;
    noAllowExternalCache = true;
    pinentry = {
      program = pkgs.pinentry-gtk2;
      grabKeyboardAndMouse = true;
    };
  };
}
