#!/bin/bash
set -euo pipefail

HOSTNAME="derper.example.org"
VERIFY_URL="https://example.org/verify"

# Setup script for derper systemd service
echo "Setting up derper service..."

# Get user input for customization
echo ""
echo "=== Configuration ==="
read -p "Do you want to customize the configuration? (y/N): " CUSTOMIZE
CUSTOMIZE=${CUSTOMIZE:-N}
if [[ ! "$CUSTOMIZE" =~ ^[Yy]$ ]]; then

    read -p "Enter hostname (default: derper.example.org): " HOSTNAME
    HOSTNAME=${HOSTNAME:-derper.example.org}

    read -p "Enter verify-client-url (default: https://example.org/verify for headscale): " VERIFY_URL
    VERIFY_URL=${VERIFY_URL:-https://example.org/verify}
else
    echo "You can customize the parameters in the derper.service file."
fi

echo ""
echo "Using hostname: $HOSTNAME"
echo "Using verify-client-url: $VERIFY_URL"
echo ""

read -n 1 -s -r -p "Press any key to continue or Ctrl+C to abort..."

sudo cp ../bin/linux/amd64/derper /usr/local/bin/derper
sudo chmod 755 /usr/local/bin/derper

# Create dedicated user and group
if ! id derper >/dev/null 2>&1; then
    echo "Creating derper user and group..."
    sudo useradd --system --no-create-home --shell /usr/sbin/nologin derper
fi

# Create and set permissions for cert directory
echo "Setting up /etc/derper directory..."
sudo mkdir -p /etc/derper
sudo chown derper:derper /etc/derper
sudo chmod 750 /etc/derper

# Copy service file (assuming it's saved as derper.service)
echo "Installing systemd service file..."
if [[ ! "$CUSTOMIZE" =~ ^[Yy]$ ]]; then
    echo "Customizing derper.service with provided parameters..."
    sed -e "s|--hostname=derper.example.org|--hostname=$HOSTNAME|g" \
    -e "s|--verify-client-url=https://example.org/verify|--verify-client-url=$VERIFY_URL|g" \
    derper.service > /tmp/derper.service.tmp
else
    echo "Using derper.service."
    cp derper.service /tmp/derper.service.tmp
fi

sudo cp /tmp/derper.service.tmp /etc/systemd/system/derper.service
rm /tmp/derper.service.tmp
sudo cp derper.service /etc/systemd/system/

# Reload systemd and enable service
echo "Enabling derper service..."
sudo systemctl daemon-reload
sudo systemctl enable derper.service

# Open firewall ports (adjust for your firewall)
echo "Please manually configure firewall to allow ports 80/tcp, 443/tcp, 3478/udp"
echo "For nftables, you can use:"
echo "  sudo nft add rule inet filter input tcp dport {80,443} accept"
echo "  sudo nft add rule inet filter input udp dport 3478 accept"
echo "  sudo nft list ruleset > /etc/nftables.conf"
echo "  sudo systemctl enable nftables; systemctl start nftables"
echo ""
echo "For ufw, you can use:"
echo "  sudo ufw allow 80/tcp"
echo "  sudo ufw allow 443/tcp"
echo "  sudo ufw allow 3478/udp"
echo ""
echo "For firewalld, you can use:"
echo "  sudo firewall-cmd --permanent --add-port=80/tcp"
echo "  sudo firewall-cmd --permanent --add-port=443/tcp"
echo "  sudo firewall-cmd --permanent --add-port=3478/udp"
echo "  sudo firewall-cmd --reload"
echo ""

echo "Setup complete!"
echo ""
echo "To start the service:"
echo "  sudo systemctl start derper"
echo ""
echo "To check status:"
echo "  sudo systemctl status derper"
echo ""
echo "To view logs:"
echo "  sudo journalctl -u derper -f"
