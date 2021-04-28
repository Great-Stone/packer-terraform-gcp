locals {
  timestamp = formatdate("YYYYMMDD-hhmmss",timeadd(timestamp(), "9h"))
  credentials = var.credentials == "" ? file(var.credentials_file) : var.credentials
}

resource "null_resource" "gcloud_install" {
  triggers = {
    always_run = local.timestamp
  }

  provisioner "local-exec" {
    command = <<EOH
wget -O gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-337.0.0-linux-x86_64.tar.gz?hl=ko
tar xvf gcloud.tar.gz
mkdir -p /terraform/packer/.config/gcloud
cat <<EOT >> /terraform/packer/.config/gcloud/application_default_credentials.json
${local.credentials}
EOT
EOH
  }
}

resource "null_resource" "packer_install" {
  depends_on = [null_resource.gcloud_install]
  triggers = {
    always_run = local.timestamp
  }

  provisioner "local-exec" {
    command = <<EOH
cat /etc/issue
RELEASE_URL="https://releases.hashicorp.com"
VERSION=$(curl -fsS https://api.github.com/repos/hashicorp/packer/releases \
        | jq -re '.[] | select(.prerelease != true) | .tag_name' \
        | sed 's/^v\(.*\)$/\1/g' \
        | sort -V \
        | tail -1)
ZIP="packer_$${VERSION}_linux_amd64.zip"
DOWNLOAD_URL="$${RELEASE_URL}/packer/$${VERSION}/$${ZIP}"
wget -O packer.zip $${DOWNLOAD_URL}
unzip packer.zip
EOH
  }
}

resource "null_resource" "run_packer" {
  depends_on = [null_resource.packer_install]
  triggers = {
    always_run = local.timestamp
  }

  provisioner "local-exec" {
    command = <<EOH
pwd
ls
export GOOGLE_APPLICATION_CREDENTIALS=/terraform/packer/.config/gcloud/application_default_credentials.json
export PATH=$${PATH}:/terraform/packer/google-cloud-sdk/bin/
gcloud info
./packer version
./packer build -var 'image_name=${var.image_name}-${local.timestamp}' -force -color=false .
EOH
  }
}