{ pkgs, ... }:

{
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocales = [
      "ja_JP.UTF-8/UTF-8"
      "ja_JP.EUC-JP/EUC-JP"
    ];
  };

  console.keyMap = "us";
  console.font = "Lat2-Terminus16";

  time.timeZone = "America/Los_Angeles";

  fonts = {
    packages = with pkgs; [
      google-fonts
      dejavu_fonts
      noto-fonts-cjk-sans
      vista-fonts
      iosevka-bin
      font-awesome
      nerd-fonts.jetbrains-mono
    ];

    fontDir.enable = true;
  };

  # used by gammastep to shift color temperature by sunrise/sunset
  location = {
    latitude = 38.58;
    longitude = -121.49;
  };
}
