{ pkgs, lib, ... }:

{
  systemd.services.postgresql.wantedBy = lib.mkForce [ ];
  services.postgresql = {
    enable = true;
    settings = {
        listen_addresses = lib.mkForce "127.0.0.1";
      archive_mode = "on";
      archive_command = "cp %p /tmp/wal_archive/%f";
      wal_level = "replica";  # nécessaire pour l’archivage
      max_wal_senders = 3;    # utile si on fait aussi du streaming
      archive_timeout = "60s";
  };
    dataDir = "/var/lib/postgresql/16";
    authentication = ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
        local   replication     postgres                                trust
    '';
  };

  # systemd.services.postgresql = {
  #   wantedBy = [ "multi-user.target" ];
  # };
  environment.systemPackages = with pkgs; [
    dbeaver-bin
  ];
}
