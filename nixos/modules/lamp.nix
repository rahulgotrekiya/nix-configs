{ config, pkgs, ... }:

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

      Alias /phpmyadmin "/var/www/php-projects/phpmyadmin"
      <Directory "/var/www/php-projects/phpmyadmin">
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
    ensureUsers = [
      {
        name = "phpmyadmin";
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
  
  environment.systemPackages = with pkgs; [ php mariadb ];
}