{ pkgs, ... }:

let ssPort = 22334;
in
{

  #   nixos-rebuild -I nixpkgs=/etc/nixos/nixpkgs -I nixos-config=/etc/nixos/configuration.nix switch
  # nix.nixPath = [
  #   "nixpkgs=/etc/nixos/nixpkgs"
  #   "nixos-config=/etc/nixos/configuration.nix"
  # ];

  imports = [ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [
    weechat
    git
    htop
    nmon
    tmux
    vim
    fish
    ripgrep
  ];

  boot.cleanTmpDir = true;

  networking.hostName = "machine";
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ ssPort ];

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.fail2ban.enable = true;

  # breaks nixos rebuild? on 18-09
  security.pam.services.sudo.sshAgentAuth = true;
  security.pam.enableSSHAgentAuth = true;
  programs.fish.enable = true;

  programs.mosh.enable = true;

  services.shadowsocks.port = ssPort;
  services.shadowsocks.enable = true;
  services.shadowsocks.passwordFile = /etc/nixos/secrets/shadow.txt;
  services.shadowsocks.encryptionMethod = "aes-256-ctr";

  users.users.lulu = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9vbAedgr3jLGerQDVgvs5T+QPpLXnps2Olyn6GJ/Ea71VtSd+7OvjDXCZyhTZVqWzr82KsVZEDHlU2kJCUkXY4VtpU3JtYEAsNd9J8rUO55+dX5Gzbleen7ckr5tQSg3IZDMjde9Yi1hv/VF0p7tjMeAne+/JhOEHG5DyhPabrFRSPQHo8Z9PNYiqtZ4pT5l56IHR+bOOVmdTikbWQ5n4SWxyYzxceGACcCdsyT2d8T9wAYuUDhs/y4HSsUf/5l+/olA9jYE9Un+0dliF6xI7o/EzocRK2gipspbBqeG/Cr+CN8sjCh8RbAR2KvIw6sL02fPdWtE0Ar4B6LXVzDYNzXM6rHbC14QIPZsl4Ld7uqv+516A8sHU8uCC7SLOeLpT1YsdaoXBiRt8grz9xzL6OaawuBybwpxPZqgYr5qbjouEFXL7yqqZN+VLD3yYpmVCRA5k3rwlm1t0fCET8OeORnX06WFZWJOTWT2ksno9rlA4WWhFcH7dXQBZR4vU5dha0dVKiiu+1qaVDUoFo3JIJw2qaccojHk3j7r2DhYfg2Iz+RdSOJZVsnVxCOWgU7gosaUWmOkVkqZrH3VLZ1sfN53fSlw3yt+IXpIlWilnBrqWNlaF6N5dJMofuQWnGmXQYP4q263fmiak1e2p/+QIJukvTfYwcXQpC1iWfUhGrQ=="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDq/p8rnyvZDvRZh8Xb4KipGuFDstWpxySWJSZHsc7zTXZPW8WGD8VOiqxkhdXD9U6hLEElgZkvQvopAnBfFhxE3fpufkyJjlVoZtwkOTJ+uQUmE9kRNUR1mJ6Cw5PkbEnWB41N3HrjDeisD0ZWss1qAmrwLOYA1q/7MrP8ROexff8jueOlN3K1geXqxobT1+z6O53KcFJGK+Q1bMTdEXowBJ01cSjpQ3bXXk8I8OyeSraYWP5BLqH5bzLv4O91Z5Gs1Rj6kzRwOon3esnN4j3hVDhZnPQbfLr3rNNnxefMxDIjaq7T+DB49K1xmCMhuSj+5y9Yip33ppYjf8pk/4ZX lulu@lulus"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCd+dcl+26zBOXm0YbC8RWZ5hSoltJVUJLAfusx0Ds8SdTXJ4P8qPUB3d7QXwEJsRe/VEX1s/HsA/nwIV6M6eBtWuCly5Yfzi2nA9vTAwQjPMdYXsBZSadBeBhguqZwDc2uwh0AGEkA2+VEDjAab3SWGXhPGhI6W7V8hXyLdnfdmMbaQB/ZinqFUsEX5iXyjlAWIVjYW8VpiX03mwS92oLULrT5Kq/jIyQhLQW7Jo3reaQhLsF0dQcx+kzXmjL3hlR45fN7e/TX8U8nUdDqoHcPXo7fob+GHVFW3sjDQAsrO1vtOsPxFyoCIUtEL82HTWjEwd1dbNkMjw9unKooepyl lulu@edge"
    ];
  };

}

