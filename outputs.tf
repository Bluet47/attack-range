output "vm_public_ip" {
  description = "Public IP of the Attack Range VM"
  value       = google_compute_instance.attack_range_vm.network_interface[0].access_config[0].nat_ip
}
