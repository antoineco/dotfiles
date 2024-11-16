{ config, secrets, ... }:
let
  listenPort = 51820;
  ifaceName = "wg0";
  netPrefix = "10.200.200"; # /24
in
{
  age.secrets."wireguard-${ifaceName}.key" = {
    file = "${secrets}/wireguard-${ifaceName}.key.age";
    mode = "0440";
    group = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [ listenPort ];

  systemd.network = {
    netdevs."50-${ifaceName}" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = ifaceName;
        MTUBytes = "1420"; # https://gist.github.com/nitred/f16850ca48c48c79bf422e90ee5b9d95
      };
      wireguardConfig = {
        ListenPort = listenPort;
        PrivateKeyFile = config.age.secrets."wireguard-${ifaceName}.key".path;
      };
      wireguardPeers = [
        {
          AllowedIPs = [ (netPrefix + ".2/32") ];
          PublicKey = "vAVus81e6y9fOojJZQzq50n/RZL0EbyhTW5i65tppX4=";
        }
      ];
    };
    networks."50-${ifaceName}" = {
      matchConfig.Name = ifaceName;
      address = [ (netPrefix + ".1/24") ];
      networkConfig.IPMasquerade = "ipv4";
    };
  };
}
