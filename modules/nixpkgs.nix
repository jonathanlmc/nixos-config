{ inputs, ... }:

{
  nix.settings = {
    max-jobs = 16;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jonathan" ];
  };

  nixpkgs = {
    overlays = [
      inputs.claude-desktop.overlays.default
      inputs.niri.overlays.niri

      (import ../overlays/overlay.nix { inherit inputs; })
    ];

    config.allowUnfree = true;
  };

  chaotic.mesa-git.enable = true;
}
