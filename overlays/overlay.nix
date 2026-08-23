{ inputs }:

self: super: rec {
  # stdenv that lets a package build with -march=native / -mtune=native style flags
  nativeStdenv = super.impureUseNativeOptimizations super.stdenv;

  withStdenv = newStdenv: pkg:
    pkg.override { stdenv = newStdenv; };

  withNativeStdenv = withStdenv nativeStdenv;

  ### Modifications to make some packages run as fast as possible

  mpv = super.mpv.override {
    scripts = [ super.mpvScripts.vr-reversal ];
  };

  freetube = super.freetube.overrideAttrs (oldAttrs: {
    installPhase = (oldAttrs.installPhase or "") + ''
      wrapProgram $out/bin/freetube --add-flags "--enable-features=AcceleratedVideoDecodeLinuxGL"
    '';
  });

  niri-unstable = super.niri-unstable.overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or {}) // {
      RUSTFLAGS = (oldAttrs.env.RUSTFLAGS or "")
        + " -C target-cpu=native -C codegen-units=1 -C lto=fat";
    };
  });

  # temporary fix for `niri-unstable`
  #
  # this version of `libdisplay-info` was removed from nixpkgs, but
  # the `niri-flake` flake depends on it still
  libdisplay-info_0_2 = super.libdisplay-info.overrideAttrs {
    version = "0.2.0";
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = "libdisplay-info";
      rev = "0.2.0";
      hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
    };
  };

  cosmic-files = super.cosmic-files.overrideAttrs (oldAttrs:
    let
      cosmicFilesPatches = [
        ./patches/cosmic-files/0001-tab-enable-thumbnails-for-remote-drives.patch
        ./patches/cosmic-files/0002-tab-video-thumbnails.patch
        ./patches/cosmic-files/0003-tab-rotating-video-thumbnails.patch
        ./patches/cosmic-files/0004-app-enable-mouse-scrolling-through-tabs.patch
      ];
    in
    {
      patches = (oldAttrs.patches or [ ]) ++ cosmicFilesPatches;
      buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ super.ffmpeg ];

      cargoDeps = super.rustPlatform.fetchCargoVendor {
        inherit (oldAttrs) pname version src;
        patches = cosmicFilesPatches;
        hash = "sha256-Y2wIjGNBHVrJ4GVkcKP1Jp07fLqVeFfL8HitMoC7o0A=";
      };
  });

  mesa_git = withNativeStdenv super.mesa_git;

  noctalia-native = (inputs.noctalia.packages.${super.stdenv.hostPlatform.system}.default).overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or {}) // {
      NIX_CFLAGS_COMPILE   = (oldAttrs.env.NIX_CFLAGS_COMPILE or "")   + "-O3 -march=native -mtune=native";
      NIX_CXXFLAGS_COMPILE = (oldAttrs.env.NIX_CXXFLAGS_COMPILE or "") + "-O3 -march=native -mtune=native";
    };
  });
}
