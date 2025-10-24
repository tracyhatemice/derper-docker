# Derper and Derpprobe

This repository provides a Dockerized setup for running `derper` and `derpprobe`, components of Tailscale's DERP (Deterministic Exit Relay Protocol) infrastructure. `derper` acts as a relay server to facilitate communication between Tailscale clients behind NATs or firewalls, while `derpprobe` is used to monitor the health and performance of DERP servers.

## Prerequisites

- A server with a public IP address and a domain name configured to point to it.
- Docker and Docker Compose installed.

## Docker Setup

1. Copy `compose.example.yaml` to `compose.yaml`.
2. Adjust the configuration as needed for your environment.
3. Bring up the container with ```docker compose up -d```

The provided example uses Traefik to proxy ports 80 and 443, and to manage Let's Encrypt certificate issuance and renewal.

If you prefer to let derper handle Let's Encrypt certificates directly, ensure that `DERP_ADDR` is set to `:443` and `DERP_CERT_MODE` is set to `letsencrypt`.  Also ensure that ports 80/tcp, 443/tcp, and 3478/udp are exposed and mapped directly to the host.

If you want to use your own certificates, set `DERP_CERT_MODE` to `manual` and mount your certificate files into the container.

| env                    | required | description                                                                 | default value     |
| -------------------    | -------- | ----------------------------------------------------------------------      | ----------------- |
| DERP_DOMAIN            | true     | derper server hostname                                                      | your-hostname.com |
| DERP_CERT_DIR          | false    | directory to store LetsEncrypt certs (if addr's port is :443)               | /app/certs        |
| DERP_CERT_MODE         | false    | mode for getting a cert. possible options: manual, letsencrypt              | letsencrypt       |
| DERP_ADDR              | false    | listening server address                                                    | :443              |
| DERP_STUN              | false    | also run a STUN server                                                      | true              |
| DERP_STUN_PORT         | false    | The UDP port on which to serve STUN.                                        | 3478              |
| DERP_HTTP_PORT         | false    | The port on which to serve HTTP. Set to -1 to disable                       | 80                |
| DERP_VERIFY_CLIENTS    | false    | verify clients to this DERP server through a local tailscaled instance      | false             |
| DERP_VERIFY_CLIENT_URL | false    | if non-empty, an admission controller URL for permitting client connections.  For self-hosted headscale, use `https://<FQDN>/verify` | ""                |

### Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/

### Note on Client Verification

In order to use client verification, either use
1. `DERP_VERIFY_CLIENTS`, then the container needs access to Tailscale's Local API, which can usually be accessed through `/var/run/tailscale/tailscaled.sock`. If you're running Tailscale bare-metal on Linux, adding this to mount point: `/var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock`
2. or use `DERP_VERIFY_CLIENT_URL`, which is an admission controller URL for permitting client connections. For self-hosted headscale, use `https://<FQDN>/verify`.

## Binary Setup

See README.md in ```contrib``` folder.

# Todo

Mesh setup with derper and derpprobe.  Though it's not really needed unless you need high availablity and want to have multiple derp servers in the same region.  Tailscale officially advise against mesh setup for custom derp servers if not needed.

# Thanks

- [fredliang44/derper-docker](https://github.com/fredliang44/derper-docker)
- [Tailscale 使用 Derp Probe 检测自建的 Derper 服务器状态](https://blog.hellowood.dev/posts/tailscale-%E4%BD%BF%E7%94%A8-derp-probe-%E6%A3%80%E6%B5%8B%E8%87%AA%E5%BB%BA%E7%9A%84-derper-%E6%9C%8D%E5%8A%A1%E5%99%A8%E7%8A%B6%E6%80%81/)
- [浅探 Tailscale DERP 中转服务](https://kiprey.github.io/2023/11/tailscale-derp/)
