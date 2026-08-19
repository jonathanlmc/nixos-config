{ ... }:

{
  users.extraUsers.jonathan = {
    isNormalUser = true;
    home = "/home/jonathan";
    description = "Jonathan";
    extraGroups = [ "wheel" "networkmanager" "podman" "i2c" ];

    # needed for rootless podman, see https://github.com/NixOS/nixpkgs/issues/389088
    subUidRanges = [ { startUid = 100000; count = 65536; } ];
    subGidRanges = [ { startGid = 100000; count = 65536; } ];
  };
}
