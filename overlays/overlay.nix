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
  libdisplay-info_0_2 = prev.libdisplay-info.overrideAttrs {
    version = "0.2.0";
    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = "libdisplay-info";
      rev = "0.2.0";
      hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
    };
  };

  mesa_git = withNativeStdenv super.mesa_git;

  proton-cachyos-native = super.callPackage ./../pkgs/proton-cachyos.nix {
    patches = [ ./LinUwUx.patch ];
  };

  noctalia-native = (inputs.noctalia.packages.${super.stdenv.hostPlatform.system}.default).overrideAttrs (oldAttrs: {
    env = (oldAttrs.env or {}) // {
      NIX_CFLAGS_COMPILE   = (oldAttrs.env.NIX_CFLAGS_COMPILE or "")   + "-O3 -march=native -mtune=native";
      NIX_CXXFLAGS_COMPILE = (oldAttrs.env.NIX_CXXFLAGS_COMPILE or "") + "-O3 -march=native -mtune=native";
    };
  });
}
