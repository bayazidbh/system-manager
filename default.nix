{ config, lib, pkgs, ... }:

{
  config = {
    system-manager.allowAnyDistro = true; # needed to bypass current restriction to NixOS and Ubuntu
    nixpkgs.hostPlatform = "x86_64-linux"; # needed by system-manager

    # Packages to install
    systemPackages = with pkgs; [
        ripgrep fd duperemove
      ];

    # Create config files in /etc
    environment.etc = {
      "system-manager.conf.test".text = ''
        it works!!!!!
      '';
    };
  };
}
