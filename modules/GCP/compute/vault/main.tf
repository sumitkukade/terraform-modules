# modules/vault/main.tf

resource "google_compute_instance" "vault_server" {
  name         = "vault-server"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 10
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {} # Assigns a public IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Update and install dependencies
    apt-get update
    apt-get install -y unzip jq

    # Download Vault
    curl -sL https://releases.hashicorp.com/vault/${var.vault_version}/vault_${var.vault_version}_linux_amd64.zip -o vault.zip

    # Install Vault
    unzip vault.zip
    mv vault /usr/local/bin/
    chmod +x /usr/local/bin/vault

    # Create Vault user and directories
    useradd --system --home /etc/vault.d --shell /bin/false vault
    mkdir --parents /etc/vault.d
    chown --recursive vault:vault /etc/vault.d

    # Create Vault configuration file
    cat <<EOF2 > /etc/vault.d/vault.hcl
    storage "gcs" {
      bucket = "${var.gcs_bucket_name}"
    }

    listener "tcp" {
      address     = "0.0.0.0:8200"
      tls_disable = 1
    }

    ui = true
    EOF2

    chown vault:vault /etc/vault.d/vault.hcl

    # Create systemd service file
    cat <<EOF2 > /etc/systemd/system/vault.service
    [Unit]
    Description=Vault service
    Requires=network-online.target
    After=network-online.target

    [Service]
    User=vault
    Group=vault
    ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
    ExecReload=/bin/kill -HUP \$MAINPID
    KillSignal=SIGINT
    Restart=on-failure
    LimitNOFILE=65536

    [Install]
    WantedBy=multi-user.target
    EOF2

    # Enable and start Vault
    systemctl daemon-reload
    systemctl enable vault
    systemctl start vault
  EOF

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  tags = ["vault-server"]
}

resource "google_compute_firewall" "vault_firewall" {
  name    = "vault-server-allow"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  source_ranges = ["0.0.0.0/0"] # Adjust for your security requirements

  target_tags = ["vault-server"]
}
