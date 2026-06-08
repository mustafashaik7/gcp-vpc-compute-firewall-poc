variable "project_id" {
  description = "Google Cloud project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "Google Cloud region for the subnet."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud zone for Compute Engine instances."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Name of the custom VPC network."
  type        = string
  default     = "vpc-lab-network"
}

variable "subnet_name" {
  description = "Name of the custom subnet."
  type        = string
  default     = "subnet-lab-us-central1"
}

variable "subnet_cidr" {
  description = "CIDR range for the lab subnet."
  type        = string
  default     = "10.10.0.0/24"
}

variable "machine_type" {
  description = "Machine type for lab VMs."
  type        = string
  default     = "e2-micro"
}

variable "source_ip_cidr" {
  description = "Your public IP in CIDR format for SSH and optional ICMP, for example 203.0.113.10/32. Do not use 0.0.0.0/0 for SSH in production."
  type        = string
}

variable "allow_external_icmp_from_anywhere" {
  description = "Set true to allow external ICMP from 0.0.0.0/0 to the public VM. Set false to restrict ICMP to source_ip_cidr."
  type        = bool
  default     = false
}

variable "linux_image" {
  description = "Boot image for Compute Engine instances."
  type        = string
  default     = "debian-cloud/debian-12"
}
