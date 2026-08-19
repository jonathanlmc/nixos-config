{ inputs, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      # browsing, media playback, and communication
      cider-2 # todo: remove
      freetube
      imv
      mpv
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

      # shell, terminal, and file management
      cosmic-files
      fish
      lazygit
      starship
      wezterm
      yazi

      # editors and development tooling
      cargo-bloat
      clang.out
      claude-code
      cosmic-edit
      git
      helix
      rustup
      tokei # counts lines of code per language
      wild  # fast rust linker
      zed-editor

      # local ai inference and speech-to-text
      claude-desktop
      llama-cpp-vulkan
      whisper-cpp-vulkan

      # security, encryption, and vpn
      bubblewrap
      gnupg1
      gocryptfs
      keepassxc
      mullvad-vpn
      veracrypt

      # disk health, backup, and btrfs storage maintenance
      compsize # reports btrfs compression ratio/usage
      czkawka-full # duplicate file and similar-image finder
      duperemove # btrfs block-level deduplication
      quota
      rclone
      smartmontools
      snapper

      # core command line utilities
      atool
      binutils
      hexyl # hex viewer
      psmisc # killall
      python3
      ripgrep
      jq

      # media processing and downloading
      ab-av1 # automated av1 re-encoding
      ffmpeg_9-full
      mediainfo
      playerctl
      yt-dlp_git

      # archive and compression tools
      unar
      unrar

      # icon themes
      adwaita-icon-theme # mouse cursor theme
      papirus-icon-theme # icons for noctalia's taskbar widget

      # system and hardware monitoring/control
      brightnessctl # backlight control
      ddcutil # controls external monitor settings over ddc/ci
      gammastep # shifts color temperature by sunrise/sunset
      mission-center # task manager/system monitor
      rocmPackages.rocm-smi # amd gpu monitoring

      # niri / wayland desktop integration
      grim # screenshot utility
      pavucontrol # volume control GUI
      satty # screenshot annotations
      slurp # region selector, used with grim/satty for screenshots
      wl-clipboard # clipboard CLI (wl-copy/wl-paste)
      xdg-desktop-portal-gtk
      xwayland-satellite # on-demand Xwayland for X11 apps under niri

      # device and compatibility tools
      ifuse # mounts iOS devices over usb
      protonup-qt # installs/manages proton-ge and wine-ge
    ];

    sessionVariables = {
      EDITOR = "hx";
      PATH = [ "/home/jonathan/.cargo/bin/" ];
      SDL_VIDEODRIVER = "wayland";
      NIXOS_OZONE_WL = 1;
    };
  };
}
