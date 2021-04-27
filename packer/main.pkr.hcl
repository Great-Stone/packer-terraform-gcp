source "googlecompute" "basic-example" {
  project_id = var.project
  source_image = var.base_image
  ssh_username = "ubuntu"
  zone = var.zone
}

build {
  name = "packer"
  sources "sources.googlecompute.basic-example" {
      name = "packer"
      output_image = "packer"
  }

  provisioner "file"{
    source = "files/deploy_app.sh"
    destination = "/tmp/deploy_app.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo apt -y update",
      "sleep 15",
      "sudo apt -y update",
      "sudo apt -y install apache2",
      "sudo systemctl start apache2",
      "sudo chown -R ubuntu:ubuntu /var/www/html",
      "chmod +x *.sh",
      "PLACEHOLDER=${var.placeholder} WIDTH=600 HEIGHT=800 PREFIX=gs /tmp/deploy_app.sh",
    ]
  }
}