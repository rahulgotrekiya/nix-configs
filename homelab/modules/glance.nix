{ config, lib, pkgs, ... }:

{
  # Install Glance package
  environment.systemPackages = [ pkgs.glance ];

  # Glance systemd service
  systemd.services.glance = {
    description = "Glance Dashboard";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "glance";
      Group = "glance";
      ExecStart = "${pkgs.glance}/bin/glance --config /etc/glance/config.yml";
      Restart = "on-failure";
      RestartSec = "5s";

      # Security hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "full";
      ProtectHome = true;
      ReadWritePaths = [ "/var/lib/glance" "/etc/glance" ];
    };
  };

  # Create glance user
  users.users.glance = {
    isSystemUser = true;
    group = "glance";
    home = "/var/lib/glance";
    createHome = true;
  };

  users.groups.glance = {};

  # Glance configuration
  environment.etc."glance/config.yml".text = ''
    server:
      host: 0.0.0.0
      port: 8080

    branding:
      logo-text: G
      hide-footer: true

    pages:
      - name: Home
        width: slim
        hide-desktop-navigation: false
        center-vertically: true
        columns:
          - size: full
            widgets:
              - type: search
                search-engine: google
                bangs:
                  - title: YouTube
                    shortcut: "!yt"
                    url: https://www.youtube.com/results?search_query={QUERY}

              - type: monitor
                cache: 1m
                title: Services
                sites:
                      # --- Media Stack ---
                      - title: Syncthing
                        url: http://homelab:8384
                        icon: di:syncthing 
                      
                      - title: Jellyfin
                        url: http://homelab:8096
                        icon: di:jellyfin

                      - title: Sonarr
                        url: http://homelab:8989
                        icon: di:sonarr

                      - title: Radarr
                        url: http://homelab:7878
                        icon: di:radarr

                      - title: Prowlarr
                        url: http://homelab:9696
                        icon: di:prowlarr

                      - title: Bazarr
                        url: http://homelab:6767
                        icon: di:bazarr

                      - title: Transmission
                        url: http://homelab:9091
                        icon: di:transmission

                      # --- Management ---
                      - title: Portainer
                        url: http://homelab:9000
                        icon: di:portainer

                      - title: Grafana
                        url: http://homelab:3000
                        icon: di:grafana

                      - title: Uptime Kuma
                        url: http://homelab:3001
                        icon: mdi:monitor-eye

              - type: bookmarks
                groups:
                  - title: AI Tools
                    links:
                      - title: ChatGPT
                        url: https://chat.openai.com/
                      - title: Claude
                        url: https://claude.ai/
                      - title: Gemini
                        url: https://gemini.google.com/

                  - title: Messaging
                    links:
                      - title: WhatsApp Web
                        url: https://web.whatsapp.com/
                      - title: Telegram Web
                        url: https://web.telegram.org/

                  - title: Entertainment
                    links:
                      - title: YouTube
                        url: https://www.youtube.com/
                      - title: YouTube Music
                        url: https://music.youtube.com/

                  - title: Development
                    links:
                      - title: GitHub
                        url: https://github.com/


                        
      - name: homelab
        columns:
          # Left Column
          - size: small
          
            widgets:
              - type: server-stats
                servers:
                  - type: local
                    name: Services

              - type: to-do
                    
              - type: rss
                limit: 10
                collapse-after: 3
                cache: 12h
                feeds:
                  - url: https://selfh.st/rss/
                    title: selfh.st
                    limit: 4
                  - url: https://ciechanow.ski/atom.xml
                  - url: https://www.joshwcomeau.com/rss.xml
                    title: Josh Comeau
                  - url: https://samwho.dev/rss.xml
                  - url: https://ishadeed.com/feed.xml
                    title: Ahmad Shadeed

          # Middle Column - Main Content
          - size: full

            widgets:
              - type: search
                search-engine: google
                bangs:
                  - title: YouTube
                    shortcut: "!yt"
                    url: https://www.youtube.com/results?search_query={QUERY}

              - type: monitor
                cache: 1m
                title: Services
                sites:
                  # --- Media Stack ---
                  - title: Syncthing
                    url: http://homelab:8384
                    icon: di:syncthing 
                  
                  - title: Jellyfin
                    url: http://homelab:8096
                    icon: di:jellyfin

                  - title: Sonarr
                    url: http://homelab:8989
                    icon: di:sonarr

                  - title: Radarr
                    url: http://homelab:7878
                    icon: di:radarr

                  - title: Prowlarr
                    url: http://homelab:9696
                    icon: di:prowlarr

                  - title: Lidarr
                    url: http://homelab:8686
                    icon: di:lidarr

                  - title: Bazarr
                    url: http://homelab:6767
                    icon: di:bazarr

                  - title: Transmission
                    url: http://homelab:9091
                    icon: di:transmission

                  # --- Management ---
                  - title: Portainer
                    url: http://homelab:9000
                    icon: di:portainer

                  - title: Grafana
                    url: http://homelab:3000
                    icon: di:grafana

                  - title: Uptime Kuma
                    url: http://homelab:3001
                    icon: mdi:monitor-eye

              - type: videos
                channels:
                  - UCXuqSBlHAE6Xw-yeJA0Tunw # Linus Tech Tips
                  - UCR-DXc1voovS8nhAvccRZhg # Jeff Geerling
                  - UCsBjURrPoezykLs9EqgamOA # Fireship
                  - UCBJycsmduvYEL83R_U4JriQ # Marques Brownlee
                  - UCHnyfMqiRRG1u-2MsSQLbXA # Veritasium

              - type: group
                widgets:
                  - type: reddit
                    subreddit: homelab
                  - type: reddit
                    subreddit: unixporn
                    show-thumbnails: true
                  - type: reddit
                    subreddit: gamingnews
                    show-thumbnails: true
                    collapse-after: 6

          # Right Column
          - size: small
            widgets:
              - type: clock
                hour-format: 24h
                timezones:
                  - timezone: Asia/Kolkata
                    label: India

              - type: weather
                location: Ahmedabad, Gujarat, India
                units: metric
                hide-location: false
          
              - type: calendar
                first-day-of-week: monday

    # Theme configuration
    theme:
        background-color: 240 13 14
        primary-color: 51 33 68
        negative-color: 358 100 68
        contrast-multiplier: 1.2
  '';

  # Copy config to glance home directory on activation
  systemd.tmpfiles.rules =  lib.mkAfter [
    "d /var/lib/glance 0755 glance glance -"
    "f /var/lib/glance/glance.yml 0644 glance glance -"
  ];

  # Open firewall for Glance
  networking.firewall.allowedTCPPorts = [ 8080 ];
}

