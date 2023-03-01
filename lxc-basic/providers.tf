terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.13"
    }
  }
}


provider "proxmox" {
  pm_api_url = "${var.PM_API_URL}"
  pm_user    = "${var.PM_USER}"
  pm_password = "${var.PM_PASS}"
  pm_tls_insecure = "true"
}
