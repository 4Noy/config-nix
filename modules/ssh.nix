{ root, config, pkgs, ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 30;
        serverAliveCountMax = 2;
        forwardX11 = false;
        strictHostKeyChecking = "ask";
        userKnownHostsFile = "~/.ssh/known_hosts";
        identitiesOnly = true;
      };
    };
  };
}
