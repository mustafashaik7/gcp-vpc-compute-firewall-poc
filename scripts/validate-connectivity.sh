#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <zone> <public-vm-name> <private-vm-internal-ip> [public-vm-external-ip]"
  echo "Example: $0 us-central1-a public-test-vm 10.10.0.3 34.123.45.67"
  exit 1
fi

ZONE="$1"
PUBLIC_VM="$2"
PRIVATE_IP="$3"
PUBLIC_EXTERNAL_IP="${4:-}"

echo "== Validation: SSH to public VM =="
gcloud compute ssh "$PUBLIC_VM" --zone "$ZONE" --command "hostname && hostname -I"

echo "== Validation: internal ICMP from public VM to private VM =="
gcloud compute ssh "$PUBLIC_VM" --zone "$ZONE" --command "ping -c 4 $PRIVATE_IP"

echo "== Validation: internal SSH reachability from public VM to private VM =="
gcloud compute ssh "$PUBLIC_VM" --zone "$ZONE" --command "nc -vz -w 5 $PRIVATE_IP 22 || true"

if [ -n "$PUBLIC_EXTERNAL_IP" ]; then
  echo "== Validation: external ICMP to public VM =="
  ping -c 4 "$PUBLIC_EXTERNAL_IP"
else
  echo "Skipping external ICMP test. Provide public VM external IP as the 4th argument to test it."
fi
