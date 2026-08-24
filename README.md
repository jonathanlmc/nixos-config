Personal system configuration for [NixOS](https://nixos.org).

## Custom Patches For `cosmic-files`

There's a certified slop™[^1] patch set for `cosmic-files` 1.5 / 1.6 [here](./overlays/patches/cosmic-files) with the following changes / features:

* Enable thumbnail generation for remote drives.
* Add static video thumbnail generation, and animated thumbnail generation for the grid view.
* Add 3-way thumbnails for folders to preview its content. Media files are prioritized first, and looked for 3 layers deep.
* Add mouse wheel scrolling through opened tabs.

You can apply all of the patches in your own overlay like so:

```nix
cosmic-files = super.cosmic-files.overrideAttrs (oldAttrs:
  let
    cosmicFilesPatches = [
      # can be applied independently
      ./patches/cosmic-files/0001-tab-enable-thumbnails-for-remote-drives.patch

      # can be applied independently
      ./patches/cosmic-files/0002-tab-video-thumbnails-3-way-folder-previews.patch

      # can be applied independently
      ./patches/cosmic-files/0003-app-enable-mouse-scrolling-through-tabs.patch
    ];
  in
  {
    patches = (oldAttrs.patches or [ ]) ++ cosmicFilesPatches;
    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.ffmpeg ];

    cargoDeps = super.rustPlatform.fetchCargoVendor {
      inherit (oldAttrs) pname version src;
      patches = cosmicFilesPatches;
      // replace hash after first rebuild attempt
      hash = super.lib.fakeHash;
    };
});
```

[^1]: All of the patches were created entirely by a LLM, since I did not want to spend a lot of time on them. The code has been manually reviewed, and the quality is okay-ish.