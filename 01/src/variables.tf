variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "token" {
  type = string
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type = string
}

variable "nat_image_id" {
  type    = string
  default = "fd80mrhj8fl2oe87o4e1"
}
