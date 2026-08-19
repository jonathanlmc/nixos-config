{ ... }:

{
  networking = {
    firewall.enable = true;

    enableIPv6 = false;
    hostName = "jonathan-desktop";

    networkmanager.enable = true;

    hosts = {
      # block ads/tracking at the hosts-file level, backup in case my pi-hole is down, or my vpn doesn't catch it
      "0.0.0.0" = [
        # Firefox
        "location.services.mozilla.com"
        "shavar.services.mozilla.com"
        "incoming.telemetry.mozilla.org"
        "ocsp.sca1b.amazontrust.com"

        # Unity games
        "config.uca.cloud.unity3d.com"
        "api.uca.cloud.unity3d.com"
        "cdp.cloud.unity3d.com"

        # Unreal Engine 4 (not sure if games actually connect to these)
        "tracking.epicgames.com"
        "tracking.unrealengine.com"

        # Redshell (game analytics)
        "redshell.io"
        "www.redshell.io"
        "api.redshell.io"
        "treasuredata.com"
        "www.treasuredata.com"
        "api.treasuredata.com"
        "in.treasuredata.com"

        # GameAnalytics
        "gameanalytics.com"
        "api.gameanalytics.com"
        "rubick.gameanalytics.com"

        # Spotify
        "apresolve.spotify.com"
        "heads4-ak.spotify.com.edgesuite.net"

        # Microsoft Flight Simulator
        "vortex.data.microsoft.com"
        "web.vortex.data.microsoft.com"

        # Steam
        "googleads.g.doubleclick.net"

        # General
        "www.google-analytics.com"
        "google-analytics.com"
        "ssl.google-analytics.com"
        "www.googletagmanager.com"
        "www.googletagservices.com"
      ];

      # LAN aliases
      "192.168.0.100" = [ "rasp.pi" ];
      "192.168.0.105" = [ "n.as" ];
    };
  };
}
