resource "null_resource" "packer" {
  provisioner "local-exec" {
    command = <<EOH
RELEASE_URL="https://releases.hashicorp.com"
VERSION=$(curl -fsS https://api.github.com/repos/hashicorp/packer/releases \
        | jq -re '.[] | select(.prerelease != true) | .tag_name' \
        | sed 's/^v\(.*\)$/\1/g' \
        | sort -V \
        | tail -1)
ZIP="packer_$${VERSION}_linux_amd64.zip"
DOWNLOAD_URL="$${RELEASE_URL}/packer/$${VERSION}/$${ZIP}"
wget $${DOWNLOAD_URL}
EOH
  }
}