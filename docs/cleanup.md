# Cleanup Guide

To avoid ongoing Google Cloud charges, destroy the Terraform-managed resources after testing.

## Terraform cleanup

From the repository root:

```bash
cd terraform
terraform destroy
```

Confirm by typing:

```text
yes
```

## Verify resources were removed

Check VM instances:

```bash
gcloud compute instances list
```

Check firewall rules:

```bash
gcloud compute firewall-rules list --filter="name~'allow-.*'"
```

Check networks:

```bash
gcloud compute networks list
```

## Manual cleanup checklist

If any resources remain, remove them from Google Cloud Console:

- Compute Engine VM instances
- Custom firewall rules
- Custom subnet
- Custom VPC network
- Persistent disks, if any were retained

## Cost note

This lab uses small VM instances, but Compute Engine resources can still incur charges while running. Destroy the environment when finished.
