{ root, config, lib, pkgs, ... }:

let
  sshKeys = [
    ".ssh/id_rsa"
    ".ssh/id_ed25519"
    ".ssh/id_ecdsa"
  ];
in {
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;

    # Global settings
    hashKnownHosts = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/master-%r@%h:%p";
    controlPersist = "10m";
    forwardAgent = false;
    serverAliveInterval = 300;
    serverAliveCountMax = 2;

    # Match everything
    matchBlocks = {
      default = {
        host = "*";
        sendEnv = [];
        extraOptions = {
          StrictHostKeyChecking = "ask";
          UserKnownHostsFile = "~/.ssh/known_hosts";
          IdentitiesOnly = "yes";
          RequestTTY = "auto";
          PasswordAuthentication = "yes";
          PubkeyAuthentication = "yes";
          ChallengeResponseAuthentication = "no";
          HostbasedAuthentication = "no";
          Tunnel = "no";
          PermitLocalCommand = "no";
          ForwardX11 = "no";
        };
      };
    };
  };
}
