{ pkgs, ... }:

{
  fileSystems = let
    btrfsOpts = compressLevel: subvol: [
      "ssd"
      "compress-force=zstd:${compressLevel}"
      "subvol=${subvol}"
      "noatime"
      "nodiratime"
      "discard=async"
    ];
  in {
    # nvme ssd
    "/".options = btrfsOpts "1" "@";
    "/home".options = btrfsOpts "1" "@home";
    "/home/jonathan/projects".options = btrfsOpts "1" "@home_projects";
    "/home/jonathan/backup".options = btrfsOpts "1" "@home_backup";
    "/home/jonathan/.cache".options = btrfsOpts "1" "@home_cache";
    # second ssd
    "/media".options = btrfsOpts "1" "/";
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 32 * 1024; # 32 GiB
  }];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };

      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "btrfs" ];

    # needed by newer wine/proton ntsync-based sync primitives
    kernelModules = [ "ntsync" ];

    tmp.cleanOnBoot = true;

    # cachyos kernel with zen4 optimizations
    kernelPackages = pkgs.linuxPackages_cachyos-lto.cachyOverride {
      cachyVars = pkgs.linuxPackages_cachyos-lto.kernel.cachyConfig.cachyVars // {
        "_processor_opt" = "ZEN4";
      };
    };

    # for a bypass in games running under wine that shall not be named
    kernelParams = [
      "clearcpuid=umip"
    ];
  };
}
