source "googlecompute" "basic-example" {
  project_id = var.project
  source_image = var.base_image
  ssh_username = "ubuntu"
  zone = var.zone
  disk_size = 10
  disk_type = "pd-ssd"
  image_name = "u16demo"
}

build {
  name = "packer"
  source "sources.googlecompute.basic-example" {
      name = "packer"
  }

  provisioner "file"{
    source = "./files"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get -y update",
      "sleep 15",
      "sudo apt-get -y update",
      "sudo apt-get -y install apache2",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo chown -R ubuntu:ubuntu /var/www/html",
      "chmod +x /tmp/files/*.sh",
      "PLACEHOLDER=${var.placeholder} WIDTH=600 HEIGHT=800 PREFIX=gs /tmp/files/deploy_app.sh",
    ]
  }
}