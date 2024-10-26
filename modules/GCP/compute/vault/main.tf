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

    DEBIAN_FRONTEND=noninteractive
    # Update and install prerequisites
    apt-get update -qqy
    apt-get install -qqy curl jq net-tools

    # Download and install Vault
    wget -qO- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    apt-get -qqy update && DEBIAN_FRONTEND=noninteractive apt-get install -qqy vault


    # Verify Vault installation
    vault --version

    # Create Vault configuration directory
    mkdir -p /etc/vault
    chown -R $(whoami):$(whoami) /etc/vault

    # Create a basic Vault configuration file
    cat <<VAULTCONFIG > /etc/vault/config.hcl
    listener "tcp" {
      address     = "0.0.0.0:8200"
      tls_disable = true
    }

    storage "file" {
      path = "/etc/vault/data"
    }

    ui = true
    VAULTCONFIG

    # Create Vault data directory
    mkdir -p /etc/vault/data
    chown -R $(whoami):$(whoami) /etc/vault/data

    # Set up Vault as a systemd service
    cat <<SERVICEFILE > /etc/systemd/system/vault.service
    [Unit]
    Description=Vault Secret Management Service
    Documentation=https://www.vaultproject.io/docs/
    After=network-online.target
    Wants=network-online.target

    [Service]
    ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl
    ExecReload=/bin/kill --signal HUP $MAINPID
    KillMode=process
    LimitNOFILE=65536
    Restart=on-failure
    User=$(whoami)
    Group=$(whoami)

    [Install]
    WantedBy=multi-user.target
    SERVICEFILE

    # Reload systemd and start Vault service
    systemctl daemon-reload
    systemctl enable vault
    systemctl start vault

    # Export VAULT_ADDR environment variable for CLI access
    echo 'export VAULT_ADDR="http://127.0.0.1:8200"' >> /etc/profile
    export VAULT_ADDR="http://127.0.0.1:8200"

    # Display Vault status
    vault status || echo "Vault installation and startup complete."
  EOF

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  tags = ["vault-server"]
}

# Firewall rule to allow port 8200 from all sources
resource "google_compute_firewall" "vault_firewall" {
  name    = "vault-server-allow-8200"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  source_ranges = ["0.0.0.0/0"] # Adjust for your security requirements

  target_tags = ["vault-server"]
}

# Firewall rule to allow HTTP (port 80) traffic from all sources
resource "google_compute_firewall" "vault_http" {
  name    = "vault-server-allow-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] # Adjust for your security requirements

  target_tags = ["vault-server"]
}

# Firewall rule to allow HTTPS (port 443) traffic from all sources
resource "google_compute_firewall" "vault_https" {
  name    = "vault-server-allow-https"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"] # Adjust for your security requirements

  target_tags = ["vault-server"]
}

# Firewall rule to allow Load Balancer health checks
resource "google_compute_firewall" "vault_lb_health_checks" {
  name    = "vault-server-allow-lb-health-checks"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8200"] # Adjust ports as per your health check configuration
  }

  source_ranges = [
    "35.191.0.0/16", # Google Cloud health check ranges
    "130.211.0.0/22"
  ]

  target_tags = ["vault-server"]
}
