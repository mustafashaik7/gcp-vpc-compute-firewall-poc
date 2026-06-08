provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

locals {
  common_labels = {
    project = "gcp-vpc-compute-firewall-poc"
    lab     = "vpc-firewall-compute"
  }

  public_vm_tag  = "public-vm"
  private_vm_tag = "private-vm"
  ssh_tag        = "ssh-enabled"
  lab_tag        = "vpc-lab"

  external_icmp_source_ranges = var.allow_external_icmp_from_anywhere ? ["0.0.0.0/0"] : [var.source_ip_cidr]
}

resource "google_compute_network" "lab_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "Custom VPC for Compute Engine firewall and internal IP connectivity PoC."
}

resource "google_compute_subnetwork" "lab_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.lab_vpc.id
  description   = "Custom subnet for public and private lab VMs."
}

resource "google_compute_firewall" "allow_ssh_from_my_ip" {
  name        = "allow-ssh-from-my-ip"
  network     = google_compute_network.lab_vpc.name
  description = "Allow SSH only from the configured public source IP CIDR."
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [var.source_ip_cidr]
  target_tags   = [local.ssh_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_internal_icmp" {
  name        = "allow-internal-icmp"
  network     = google_compute_network.lab_vpc.name
  description = "Allow ICMP between lab VMs over internal RFC1918 addresses."
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [var.subnet_cidr]
  target_tags   = [local.lab_tag]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_internal_ssh" {
  name        = "allow-internal-ssh"
  network     = google_compute_network.lab_vpc.name
  description = "Allow internal SSH between lab VMs using private IP addresses."
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = [var.subnet_cidr]
  target_tags   = [local.lab_tag]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_external_icmp_public_vm" {
  name        = "allow-external-icmp-public-vm"
  network     = google_compute_network.lab_vpc.name
  description = "Allow external ping to the public VM only."
  direction   = "INGRESS"
  priority    = 1000

  source_ranges = local.external_icmp_source_ranges
  target_tags   = [local.public_vm_tag]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_instance" "public_vm" {
  name         = "public-test-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [local.public_vm_tag, local.ssh_tag, local.lab_tag]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.linux_image
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab_subnet.id

    access_config {
      // Ephemeral public IP for lab access.
    }
  }

  metadata_startup_script = file("${path.module}/../scripts/startup-script.sh")
}

resource "google_compute_instance" "private_vm" {
  name         = "private-test-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = [local.private_vm_tag, local.lab_tag]
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.linux_image
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab_subnet.id
    // No access_config block means no external IP address.
  }

  metadata_startup_script = file("${path.module}/../scripts/startup-script.sh")
}
