locals {
  public_key  = var.public_key == "" ? file(var.public_key_file) : var.public_key
  private_key = var.private_key == "" ? file(var.private_key_file) : var.private_key
}

data "terraform_remote_state" "image_name" {
  backend = "remote"

  config = {
    organization = "great-stone-biz"
    workspaces = {
      name = "gcp-packer"
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "k8s-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443",
      "6443",
      "8001",
      "8080"
    ]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["k8s"]
}


resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
    //   image = var.image
      image = "gs-20210903-164934"
    }
  }

  labels = {
    name = "gslee"
    owner = "gslee"
    ttl = "48"
  }

  metadata = {
    ssh-keys = "ubuntu:${local.public_key}"
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

# Run the deploy_app.sh script.
// resource "null_resource" "configure-cat-app" {
//   depends_on = [google_compute_instance.instance]

//   triggers = {
//     build_number = timestamp()
//   }

//   provisioner "file" {
//     source      = "files/"
//     destination = "/home/ubuntu/"

//     connection {
//       type        = "ssh"
//       user        = "ubuntu"
//       private_key = local.private_key
//       host        = google_compute_instance.instance.network_interface.0.access_config.0.nat_ip
//     }
//   }

//   provisioner "remote-exec" {
//     inline = [
//       "sudo apt -y update",
//       "sleep 15",
//       "sudo apt -y update",
//       "sudo apt -y install apache2",
//       "sudo systemctl start apache2",
//       "sudo chown -R ubuntu:ubuntu /var/www/html",
//       "chmod +x *.sh",
//       "PLACEHOLDER=${var.placeholder} WIDTH=600 HEIGHT=800 PREFIX=gs ./deploy_app.sh",
//       "sudo apt -y install cowsay",
//       "cowsay Mooooooooooo!",
//     ]

//     connection {
//       type        = "ssh"
//       user        = "ubuntu"
//       private_key = local.private_key
//       host        = google_compute_instance.instance.network_interface.0.access_config.0.nat_ip
//     }
//   }
// }

output "instance_ip" {
  value = "http://${google_compute_instance.instance.network_interface.0.access_config.0.nat_ip}"
}
