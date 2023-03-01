resource "proxmox_lxc" "basic" {
  target_node  = "prolizzle"
  hostname     = "lxcBox"
  ostemplate   = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  password     = "${var.LXC_PASS}"
  unprivileged = false
  memory       = 8192
  cores        = 2
  swap         = 8192
  ostype       = "ubuntu"
  
  mountpoint {
    key     = "0"
    slot    = "0"
    storage = "${var.sharename}"
    volume  = "/mnt/pve/${var.sharename}"
    mp      = "/mnt/"
    size    = "30G"
  }

  rootfs {
    storage = "local"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
}
