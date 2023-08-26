{ config, lib, pkgs, ... }:

{
  config = {
    system-manager.allowAnyDistro = true; # needed to bypass current restriction to NixOS and Ubuntu
    nixpkgs.hostPlatform = "x86_64-linux"; # needed by system-manager

    environment = {
      # Packages to install
      systemPackages = with pkgs; [
        exa bat opensnitch opensnitch-ui
      ];
      # Create config files in /etc
      etc = {
        "containers" = {
          enable = true;
          target = "containers";
          source = "${./etc/containers}";
        };
        "qemu.conf" = {
          enable = true;
          target = "libvirt/qemu.conf.test";
          mode = "0644";
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
      "logind.conf" = {
          enable = true;
          target = "systemd/logind.conf.test";
          mode = "0644";
          user = "root";
          group = "root";
          text = ''
          # Entries in this file show the compile time defaults. Local configuration
          # should be created by either modifying this file, or by creating "drop-ins" in
          # the logind.conf.d/ subdirectory. The latter is generally recommended.
          # Defaults can be restored by simply deleting this file and all drop-ins.
          #
          # Use 'systemd-analyze cat-config systemd/logind.conf' to display the full config.
          #
          # See logind.conf(5) for details.

          [Login]
          HandleLidSwitch=suspend
          HandleLidSwitchExternalPower=ignore
          HandleLidSwitchDocked=ignore
          '';
        };
      "smb.conf" = {
          enable = true;
          target = "samba/smb.conf.test";
          mode = "0644";
          user = "root";
          group = "root";
          text = ''
          #======================= Global Settings =======================

          [global]

             workgroup = WORKGROUP
             server string = %h server (Samba, Ubuntu)

          #### Networking ####

          ;   interfaces = 127.0.0.0/8 eth0
          ;   bind interfaces only = yes

          #### Debugging/Accounting ####

             log file = /var/log/samba/log.%m
             max log size = 1000
             logging = file
             panic action = /usr/share/samba/panic-action %d

          ####### Authentication #######

             server role = standalone server
             obey pam restrictions = yes
             unix password sync = yes
             passwd program = /usr/bin/passwd %u
             passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
             pam password change = yes
             map to guest = bad user

          ########## Domains ###########

          ;   logon path = \\%N\profiles\%U
          ;   logon drive = H:
          ;   logon script = logon.cmd

          ; add user script = /usr/sbin/adduser --quiet --disabled-password --gecos "" %u
          ; add machine script  = /usr/sbin/useradd -g machines -c "%u machine account" -d /var/lib/samba -s /bin/false %u
          ; add group script = /usr/sbin/addgroup --force-badname %g

          ############ Misc ############

          ;   include = /home/samba/etc/smb.conf.%m
          ;   idmap config * :              backend = tdb
          ;   idmap config * :              range   = 3000-7999
          ;   idmap config YOURDOMAINHERE : backend = tdb
          ;   idmap config YOURDOMAINHERE : range   = 100000-999999
          ;   template shell = /bin/bash
             usershare max shares = 100
             usershare allow guests = yes
             allow insecure wide links = yes
             acl allow execute always = True

          #======================= Share Definitions =======================

          ;[homes]
          ;   comment = Home Directories
          ;   browseable = no
          ;   read only = yes
          ;   create mask = 0700
          ;   directory mask = 0700
          ;   valid users = %S

          ;[netlogon]
          ;   comment = Network Logon Service
          ;   path = /home/samba/netlogon
          ;   guest ok = yes
          ;   read only = yes

          ;[profiles]
          ;   comment = Users profiles
          ;   path = /home/samba/profiles
          ;   guest ok = no
          ;   browseable = no
          ;   create mask = 0600
          ;   directory mask = 0700

          [printers]
             comment = All Printers
             browseable = no
             path = /var/spool/samba
             printable = yes
             guest ok = no
             read only = yes
             create mask = 0700

          [print$]
             comment = Printer Drivers
             path = /var/lib/samba/printers
             browseable = yes
             read only = yes
             guest ok = no
          ;   write list = root, @lpadmin

          [Home]
             comment = fenglengshun Home dir
             path = /home/fenglengshun
             writeable = yes
             browseable = yes
             public = yes
             create mask = 0755
             directory mask = 0755
             write list = user
             valid users = fenglengshun
             follow symlinks = yes

          [Mount]
             comment = device mnt dir
             path = /mnt
             writeable = yes
             browseable = yes
             public = yes
             create mask = 0755
             directory mask = 0755
             write list = user
             valid users = fenglengshun
             follow symlinks = yes

          '';
        };
      };
    };
  };
}
