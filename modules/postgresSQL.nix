{ pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    settings = {
        listen_addresses = lib.mkForce "127.0.0.1";
    };
    authentication = ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     trust
        host    all             all             127.0.0.1/32            trust
        host    all             all             ::1/128                 trust
    '';
  };

  systemd.services.postgresql = {
    wantedBy = [ "multi-user.target" ];
  };
  environment.systemPackages = with pkgs; [
    dbeaver-bin
  ];
}
