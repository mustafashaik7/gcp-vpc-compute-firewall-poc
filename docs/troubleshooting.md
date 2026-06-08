# Troubleshooting Guide

## SSH to public VM fails

Check the following:

1. Confirm your current public IP matches `source_ip_cidr` in `terraform.tfvars`.
2. Confirm the VM has the `ssh-enabled` network tag.
3. Confirm the firewall rule `allow-ssh-from-my-ip` exists.
4. Confirm the VM has an external IP.
5. Confirm you are using the correct zone.

Useful commands:

```bash
gcloud compute instances list
gcloud compute firewall-rules describe allow-ssh-from-my-ip
curl ifconfig.me
```

If your IP changed, update `terraform.tfvars` and run:

```bash
terraform apply
```

## External ping fails

Check the following:

1. Confirm the public VM has the `public-vm` tag.
2. Confirm the source range for `allow-external-icmp-public-vm` includes your public IP.
3. Confirm your local network does not block outbound ICMP.
4. Confirm you are pinging the public VM's external IP, not the private IP.

Useful command:

```bash
gcloud compute firewall-rules describe allow-external-icmp-public-vm
```

## Internal ping to private VM fails

Check the following:

1. Confirm both VMs are in the same VPC and subnet.
2. Confirm the private VM has the `vpc-lab` tag.
3. Confirm the firewall rule `allow-internal-icmp` exists.
4. Confirm you are pinging the private VM's internal IP.

Useful commands:

```bash
gcloud compute instances list
gcloud compute firewall-rules describe allow-internal-icmp
```

## Private VM has no outbound internet

This is expected. The private VM has no external IP and this PoC does not deploy Cloud NAT by default.

To allow outbound internet access from the private VM without assigning an external IP, add Cloud Router and Cloud NAT resources.

## Terraform destroy fails

Common reasons:

- Active SSH session or resource dependency delay.
- Project permissions issue.
- API or provider error.

Retry:

```bash
terraform destroy
```

If needed, verify remaining resources manually in Google Cloud Console.
