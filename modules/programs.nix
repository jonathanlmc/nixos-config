{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      vendor.completions.enable = false;
    };

    fuse.userAllowOther = true;

    gnupg.agent.enable = true;
    firejail.enable = true;
    nix-ld.enable = true;

    solaar = {
      enable = true;
      userService.enable = true;
    };

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
      useNautilus = false;
    };

    noctalia = {
      enable = true;
      package = pkgs.noctalia-native;
      recommendedServices.enable = true;
    };
  };
}
