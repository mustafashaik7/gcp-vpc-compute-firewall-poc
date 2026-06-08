output "vpc_name" {
  description = "Custom VPC name."
  value       = google_compute_network.lab_vpc.name
}

output "subnet_name" {
  description = "Custom subnet name."
  value       = google_compute_subnetwork.lab_subnet.name
}

output "public_vm_name" {
  description = "Public VM name."
  value       = google_compute_instance.public_vm.name
}

output "public_vm_external_ip" {
  description = "External IP of the public VM."
  value       = google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip
}

output "public_vm_internal_ip" {
  description = "Internal IP of the public VM."
  value       = google_compute_instance.public_vm.network_interface[0].network_ip
}

output "private_vm_name" {
  description = "Private VM name."
  value       = google_compute_instance.private_vm.name
}

output "private_vm_internal_ip" {
  description = "Internal IP of the private VM."
  value       = google_compute_instance.private_vm.network_interface[0].network_ip
}

output "ssh_public_vm_command" {
  description = "Command to SSH into the public VM."
  value       = "gcloud compute ssh ${google_compute_instance.public_vm.name} --zone ${var.zone}"
}

output "ping_public_vm_command" {
  description = "Command to ping the public VM external IP."
  value       = "ping ${google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip}"
}

output "ping_private_vm_from_public_vm_command" {
  description = "Run from inside public-test-vm to test internal ICMP."
  value       = "ping ${google_compute_instance.private_vm.network_interface[0].network_ip}"
}
