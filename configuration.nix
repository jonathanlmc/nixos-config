{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/boot.nix
    ./modules/locale.nix
    ./modules/nixpkgs.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/networking.nix
    ./modules/hardware.nix
    ./modules/users.nix
  ];

  system.stateVersion = "26.05";
}
