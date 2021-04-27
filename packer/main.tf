locals {
  timestamp = timestamp()
  credentials = var.credentials == "" ? file(var.credentials_file) : var.credentials
}

resource "null_resource" "gcloud_install" {
  triggers = {
    always_run = local.timestamp
  }

  provisioner "local-exec" {
    command = <<EOH
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-sdk
mkdir -p ~/.config/gcloud
echo ${credentials} > ~/.config/gcloud/application_default_credentials.json
gcloud info
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
./packer version
EOH
  }
}