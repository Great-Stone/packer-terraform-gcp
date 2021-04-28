variable "project" {
  default = "gs-test-282101"
}
variable "region" {
  default = "asia-northeast2"
}
variable "zone" {
  default = "asia-northeast2-a"
}
variable "credentials" {
  default = ""
}
variable "credentials_file" {
  default = "../../gcp-gs-test-282101.json"
}
variable "private_key_file" {
  default = "../../.ssh/id_rsa"
}
variable "private_key" {
  default = ""
}
variable "public_key_file" {
  default = "../../.ssh/id_rsa.pub"
}
variable "public_key" {
  default = ""
}
variable "instance_name" {
  default = "packer-instance"
}
#n2-standard-16
variable "machine_type" {
  default = "g1-small"
}
variable "image" {
  default = "ubuntu-1804-bionic-v20210415"
}
variable "placeholder" {
  default     = "placekitten.com"
  description = "Image-as-a-service URL. Some other fun ones to try are fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com, placedog.net"
}