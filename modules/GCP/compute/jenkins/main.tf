# Create a Google Compute Engine instance for Jenkins
resource "google_compute_instance" "jenkins_instance" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts" # or another desired image
      size  = var.disk_size
    }
  }

  network_interface {
    network = var.network
    access_config {}
  }

  tags = ["jenkins"]

  # Metadata for startup script to install Jenkins
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update
    apt-get install -y jenkins
    systemctl enable jenkins
    systemctl start jenkins
  EOT
}

# Firewall rule to allow HTTP/HTTPS access to Jenkins
resource "google_compute_firewall" "jenkins_firewall" {
  name    = "${var.instance_name}-firewall"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["8080", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
}
