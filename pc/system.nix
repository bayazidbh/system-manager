{ config, lib, pkgs, ... }:

{
  config = {
    environment = {
      etc = {
        "foo.conf".text = ''
          launch_the_rockets = true
        '';
      };
      systemPackages = with pkgs; [
        ripgrep fd duperemove
      ];
    };

    systemd.services = {
      foo = {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        wantedBy = [ "system-manager.target" ];
        script = ''
          ${lib.getBin pkgs.foo}/bin/foo
          echo "We launched the rockets!"
        '';
      };
    };
  };
}
