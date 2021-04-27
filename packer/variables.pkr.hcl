variable "base_image" {
  default = "ubuntu-1804-bionic-v20210415"
}
variable "project" {
  default = "gs-test-282101"
}
variable "region" {
  default = "asia-northeast2"
}
variable "zone" {
  default = "asia-northeast2-a"
}
variable "image_name" {
  
}
variable "placeholder" {
  default     = "placekitten.com"
  description = "Image-as-a-service URL. Some other fun ones to try are fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com, placedog.net"
}