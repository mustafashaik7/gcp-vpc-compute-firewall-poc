# Lab Notes

## Purpose

This PoC maps directly to common Google Cloud VPC and Compute Engine networking tasks:

- Create a custom VPC.
- Create a custom subnet.
- Deploy Compute Engine VMs.
- Control access using firewall rules.
- Validate internal IP and external IP connectivity.

## Why two VMs?

The project uses two VMs to clearly separate external and internal access patterns:

- `public-test-vm` has an external IP and can be reached from a trusted admin source.
- `private-test-vm` has no external IP and is reachable only through the VPC private network.

This proves understanding of public vs private network exposure.

## Why use network tags?

Firewall rules use target tags to apply access only to intended VMs.

Examples:

- `public-vm` receives external ICMP access.
- `ssh-enabled` receives SSH from the trusted source.
- `vpc-lab` receives internal ICMP and internal SSH.

This avoids broad rules that accidentally apply to unrelated workloads.

## Why restrict SSH?

Opening SSH to `0.0.0.0/0` is risky. This PoC restricts SSH to `source_ip_cidr`, which should be your public IP with `/32`.

## What this demonstrates in interviews

This project demonstrates that you can design, deploy, validate, troubleshoot, and document Google Cloud VPC networking and firewall behavior using Terraform.
