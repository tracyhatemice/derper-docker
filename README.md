# Derper

# Docker Setup

> required: copy compose.example.yaml to compose.yaml and adjust according to your needs.

```bash
docker compose up -d
```

| env                    | required | description                                                                 | default value     |
| -------------------    | -------- | ----------------------------------------------------------------------      | ----------------- |
| DERP_DOMAIN            | true     | derper server hostname                                                      | your-hostname.com |
| DERP_CERT_DIR          | false    | directory to store LetsEncrypt certs(if addr's port is :443)                | /app/certs        |
| DERP_CERT_MODE         | false    | mode for getting a cert. possible options: manual, letsencrypt              | letsencrypt       |
| DERP_ADDR              | false    | listening server address                                                    | :443              |
| DERP_STUN              | false    | also run a STUN server                                                      | true              |
| DERP_STUN_PORT         | false    | The UDP port on which to serve STUN.                                        | 3478              |
| DERP_HTTP_PORT         | false    | The port on which to serve HTTP. Set to -1 to disable                       | 80                |
| DERP_VERIFY_CLIENTS    | false    | verify clients to this DERP server through a local tailscaled instance      | false             |
| DERP_VERIFY_CLIENT_URL | false    | if non-empty, an admission controller URL for permitting client connections | ""                |

# Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/

## Client verification

In order to use `DERP_VERIFY_CLIENTS`, the container needs access to Tailscale's Local API, which can usually be accessed through `/var/run/tailscale/tailscaled.sock`. If you're running Tailscale bare-metal on Linux, adding this to the `docker run` command should be enough: `-v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock`

# Binary Setup

See README.md in ```contrib``` folder.

