resource "google_compute_network" "attack_range_vpc" {
  name                    = "attack-range-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "attack_range_subnet" {
  name          = "attack-range-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.attack_range_vpc.id
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.attack_range_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["attack-range-vm"]
}

resource "google_compute_instance" "attack_range_vm" {
  name         = "attack-range-vm"
  machine_type = "e2-standard-2"
  zone         = var.zone

  tags = ["attack-range-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 50
    }
  }

  network_interface {
    network    = google_compute_network.attack_range_vpc.id
    subnetwork = google_compute_subnetwork.attack_range_subnet.id

    access_config {} # Ephemeral IP
  }

  metadata_startup_script = file("startup.sh")

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
