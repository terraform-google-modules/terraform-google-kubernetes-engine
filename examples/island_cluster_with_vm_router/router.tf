resource "google_compute_instance" "vm" {
  project                   = var.project_id
  zone                      = var.node_locations[0]
  name                      = "${var.cluster_name}-router-${random_id.rand.hex}"
  machine_type              = var.router_machine_type
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  can_ip_forward = true
  shielded_instance_config {
    enable_secure_boot = true
  }
  network_interface {
    subnetwork = var.primary_subnet
  }
  network_interface {
    subnetwork = module.net.subnets["${var.region}/${var.cluster_name}-${var.region}-snet"]["self_link"]
  }
  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -ex
    sudo apt-get update
    echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    sudo iptables -A FORWARD -i ens5 -o ens4 -j ACCEPT
    sudo iptables -A FORWARD -i ens4 -o ens5 -m state --state ESTABLISHED,RELATED -j ACCEPT
    GWY_URL="http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/1/gateway"
    GWY_IP=$(curl $${GWY_URL} -H "Metadata-Flavor: Google")
    sudo ip route add ${var.secondary_ranges["pods"]} via $${GWY_IP} dev ens5
    sudo iptables -t nat -A POSTROUTING -o ens4 -s 0.0.0.0/0 -j MASQUERADE
  EOT
}
