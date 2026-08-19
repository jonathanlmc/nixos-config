{ pkgs, ... }:

{
  services = {
    btrfs.autoScrub.enable = true;

    xserver.videoDrivers = [ "amdgpu" ];

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      autoLogin.enable = true;
      autoLogin.user = "jonathan";
    };

    # lets ps4 controllers be used without root access, needed for things like rpcs3
    udev.extraRules = ''
      KERNEL=="uinput", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:09CC.*", MODE="0666"
    '';

    earlyoom = {
      enable = true;
      freeMemThreshold = 3;
    };

    chrony.enable = true;
    sshd.enable = true;

    flatpak.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    mullvad-vpn.enable = true;

    snapper.configs = {
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };

    syncthing = {
      enable = true;
      user = "jonathan";
      dataDir = "/home/jonathan/.syncthing";
      openDefaultPorts = true;
    };

    scx.enable = true;
  };

  # niri is wlroots-based, so xdg-desktop-portal-wlr covers screenshots/screen-sharing
  # xdg-desktop-portal-gtk covers file pickers etc, kept for flatpak
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  systemd = {
    # avoids long shutdown hangs waiting on user services to stop
    services."user@".serviceConfig = {
      TimeoutStopSec = "15s";
    };
  };

  security = {
    # needed for pipewire's realtime scheduling
    rtkit.enable = true;
  };

  virtualisation.podman.enable = true;
}
