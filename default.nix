{ config, lib, pkgs, ... }:

{
  config = {
    system-manager.allowAnyDistro = true; # needed to bypass current restriction to NixOS and Ubuntu
    nixpkgs.hostPlatform = "x86_64-linux"; # needed by system-manager

    environment = {
      # Packages to install
      systemPackages = with pkgs; [
        bat
      ];
      # Create config files in /etc
      etc = {
        "qemu.conf.test" = {
          enable = true;
          target = "libvirt/qemu.conf.test";
          mode = "0600";
          user = "root";
          group = "root";
          text = ''
            # Master configuration file for the QEMU driver.
            # All settings described here are optional - if omitted, sensible
            # defaults are used.

            #security_driver = [ "selinux", "apparmor" ]
            #security_driver = "selinux"

            group = "fenglengshun"
            dynamic_ownership = 1
            remember_owner = 1
            swtpm_user = "swtpm"
            swtpm_group = "swtpm"
          '';
        };
      };
    };
  };
}
