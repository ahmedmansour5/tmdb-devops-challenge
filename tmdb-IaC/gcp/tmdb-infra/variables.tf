variable "project_id" {
}

variable "region" {
}

variable "zone" {
}

variable "zone2" {
}

variable "tmdb_ssh_user" {
  default = "tmdb"
}

variable "tmdb_ssh_pub_key_file" {
  default = "../../../tmdb-keys/tmdb-monitoring.pub"
}

variable "tmdb_ssh_private_key_file" {
  default = "../../../tmdb-keys/tmdb-monitoring.key"
}

