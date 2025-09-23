# Run derper as a systemd service 

Run derper as a systemd service without docker, with automatic TLS via Let's Encrypt.

## Setup

Review the setup.sh script to see if the workflow works for you.

Run setup.sh script to install derper binary and systemd service file. You can customize hostname and verify-client-url during setup.  For more customization, edit the ```systemd/derper.service``` file directly.

Full list of derper arguments can be found in the [derper documentation](https://github.com/tailscale/tailscale/blob/main/cmd/derper/derper.go)

```bash
chmod +x setup.sh
./setup.sh
```

## Security Setup

- **Minimal privileges**: Runs as dedicated `derper` user with no shell access
- **Capability-based port binding**: Uses `CAP_NET_BIND_SERVICE` to bind privileged ports without running as root
- **Filesystem restrictions**: Can only write to `/etc/derper`, all other paths are read-only
- **System call filtering**: Restricts available system calls to service-appropriate ones
- **Memory protection**: Prevents executable memory allocation
- **Process isolation**: Private /tmp, no access to devices or home directories

## Notes

- The service will automatically restart on failure
- Logs are available via `journalctl -u derper -f`
- The setup assumes your derper binary is at `/usr/local/bin/derper` - adjust the path in the service file if needed
- The service uses Let's Encrypt for certificates, so ensure your domain points to this server

