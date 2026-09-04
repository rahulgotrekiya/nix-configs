# LAMP stack — Apache + PHP + MariaDB + phpMyAdmin
# Import this in any host that needs a local web development environment.
{ pkgs, ... }:

let
  # phpMyAdmin source + generated config, served read-only from the store.
  phpmyadminSrc = pkgs.fetchzip {
    url = "https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.zip";
    hash = "sha256-zmwPMCVo/FekXFHFHRhvLfrq+Mt4nKoe/4r8d5vQxoQ=";
  };
  phpmyadmin = pkgs.runCommand "phpmyadmin-root" { } ''
    cp -r ${phpmyadminSrc} $out
    chmod -R u+w $out
    cp ${pkgs.writeText "config.inc.php" ''
      <?php
      // ponytail: hardcoded blowfish secret, fine for localhost dev (encrypts cookie, not the DB).
      $cfg['blowfish_secret'] = 'nixlocaldevphpmyadmin0123456789ab';
      $i = 0;
      $i++;
      $cfg['Servers'][$i]['auth_type'] = 'config';
      $cfg['Servers'][$i]['user']      = 'wwwrun';
      $cfg['Servers'][$i]['host']      = 'localhost';
      $cfg['Servers'][$i]['socket']    = '/run/mysqld/mysqld.sock';
      $cfg['Servers'][$i]['AllowNoPassword'] = true;  // wwwrun logs in via unix_socket, no password
      $cfg['TempDir'] = '/var/cache/phpmyadmin';
    ''} $out/config.inc.php
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.httpd = {
    enable = true;
    enablePHP = true;
    phpPackage = pkgs.php83;
    extraModules = [ "alias" ];
    virtualHosts."localhost" = {
      documentRoot = "/mnt/work/study/projects/php-root";
    };
    extraConfig = ''
      DirectoryIndex index.php index.html
      <Directory "/mnt/work/study/projects/php-root">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
      </Directory>

      Alias /phpmyadmin "${phpmyadmin}"
      <Directory "${phpmyadmin}">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
      </Directory>
    '';
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "phpmyadmin" ];
    ensureUsers = [{
      # Apache runs PHP as wwwrun; phpMyAdmin logs in via the socket as this user (unix_socket auth).
      name = "wwwrun";
      ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
    }];
  };

  systemd.tmpfiles.rules = [ "d /var/cache/phpmyadmin 0700 wwwrun wwwrun -" ];

  environment.systemPackages = with pkgs; [
    php
    mariadb
  ];
}
