# --mesh-psk-file flag

```markdown
```go
meshPSKFile = flag.String("mesh-psk-file", defaultMeshPSKFile()
```

## Purpose
This flag specifies the path to a file containing a mesh pre-shared key (PSK) that allows multiple DERP servers in the same region to authenticate with each other and form a mesh network for redundancy.

## How it works
- The PSK file contains a shared secret key (typically a 64+ character hexadecimal string) that multiple DERP servers must share to communicate securely
- When used with the `--mesh-with` flag, it enables DERP servers to connect to each other and forward packets between nodes in the same region
- If you try to use `--mesh-with` without providing `--mesh-psk-file`, the server will return an error: "--mesh-with requires --mesh-psk-file"

## Context
Tailscale runs multiple DERP nodes per region "meshed" together for redundancy - this allows for cloud failures or upgrades without kicking users out to a higher latency region. Each node in the region must be meshed with every other node and forward packets to other nodes within the region.

## Usage
The flag allows you to run commands like:
```bash
derper --mesh-with=derp2.example.com,derp3.example.com --mesh-psk-file=/path/to/shared-secret.key
```
