output "jenkins_instance_ip" {
  description = "The external IP address of the Jenkins instance"
  value       = google_compute_instance.jenkins_instance.network_interface[0].access_config[0].nat_ip
}

output "jenkins_url" {
  description = "The Jenkins URL"
  value       = "http://${google_compute_instance.jenkins_instance.network_interface[0].access_config[0].nat_ip}:8080"
}
