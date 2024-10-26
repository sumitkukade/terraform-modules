# Create a Google Compute Engine instance for Jenkins
resource "google_compute_instance" "jenkins_instance" {
  name                      = var.instance_name
  machine_type              = var.instance_type
  zone                      = var.zone
  allow_stopping_for_update = var.allow_stopping_for_update


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
    set -e
    export DEBIAN_FRONTEND=noninteractive
    apt update -qqy
    apt install -qqy fontconfig openjdk-17-jre
    wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt update -qqy
    apt install -qqy jenkins
    systemctl enable jenkins
    systemctl start jenkins
    echo "Jenkins installed. Access at http://$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip -H "Metadata-Flavor: Google"):8080"
    echo "Initial admin password: cat /var/lib/jenkins/secrets/initialAdminPassword"
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
