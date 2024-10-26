# Jenkins Module

This module sets up a Jenkins server on GCP using Terraform. It provisions a Compute Engine instance, installs Jenkins, and creates a firewall rule for HTTP/HTTPS access.

## Usage

```hcl
module "jenkins" {
  source       = "./modules/jenkins"
  instance_name = "jenkins-server"
  region       = "us-central1"
  zone         = "us-central1-a"
  instance_type = "e2-medium"
  disk_size    = 50
  network      = "default"
}

```
