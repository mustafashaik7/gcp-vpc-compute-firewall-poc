#!/usr/bin/env bash
set -euo pipefail

apt-get update -y
apt-get install -y curl net-tools iputils-ping dnsutils

cat >/etc/motd <<'MOTD'
GCP VPC Compute Firewall PoC VM
Validation ideas:
- Check internal IP: hostname -I
- Test ICMP: ping <private-ip>
- Test HTTP metadata: curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/name
MOTD
