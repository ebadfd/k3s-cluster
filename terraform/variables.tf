variable "pve_node" {
  type    = string
  default = "kaede"
}

variable "pve_username" {
  type = string
}

variable "pve_password" {
  type = string
}

variable "pve_datastore_id" {
  type    = string
  default = "VE_storage"
}

variable "pve_local_datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "pve_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = true
}

variable "pve_host" {
  description = "The hostname or IP of the proxmox server"
  type        = string
}

variable "k3s_master_nodes" {
  default = 1
}

variable "k3s_master_mem" {
  default = "4096"
}

variable "k3s_worker_nodes" {
  default = 3
}

variable "k3s_worker_mem" {
  default = "2048"
}

variable "master_ips" {
  description = "List of ip addresses for master nodes"
  default = [
    "10.20.23.81",
    "10.20.23.82",
    "10.20.23.83"
  ]
}

variable "worker_ips" {
  description = "List of ip addresses for worker nodes"
  default = [
    "10.20.23.91",
    "10.20.23.92",
    "10.20.23.93",
    "10.20.23.94"
  ]
}

variable "networkrange" {
  default = 24
}

variable "gateway" {
  default = "10.20.23.1"
}
