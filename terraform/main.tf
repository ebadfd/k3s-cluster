terraform {
  backend "s3" {
    key                         = "k3s-cluster-storage/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "proxmox" {
  endpoint = "https://${var.pve_host}:8006"

  username = var.pve_username
  password = var.pve_password

  insecure = var.pve_tls_insecure

  ssh {
    agent = true
  }
}

locals {
  cluster = "misaki"
  tags = {
    App         = "k3s"
    Environment = "production"
    Provisioner = "terraform"
  }
}

data "local_file" "ssh_public_key" {
  filename = "./id_rsa.pub"
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = var.pve_datastore_id
  node_name    = var.pve_node

  url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_vm" "proxmox_vm_master" {
  count       = var.k3s_master_nodes
  name        = "k3s-master-${count.index}"
  description = "Managed by Terraform"
  tags        = ["k3s", "terraform", "k3s-master"]

  node_name = var.pve_node

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k3s_master_mem
    floating  = var.k3s_master_mem
  }

  disk {
    datastore_id = var.pve_local_datastore_id
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 50
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.master_ips[count.index]}/${var.networkrange}"
        gateway = var.gateway
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_vm" "proxmox_vm_worker" {
  count       = var.k3s_worker_nodes
  name        = "k3s-worker-${count.index}"
  description = "Managed by Terraform"
  tags        = ["k3s", "terraform", "k3s-worker"]

  node_name = var.pve_node

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.k3s_worker_mem
    floating  = var.k3s_worker_mem
  }

  disk {
    datastore_id = var.pve_local_datastore_id
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 50
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.worker_ips[count.index]}/${var.networkrange}"
        gateway = var.gateway
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
