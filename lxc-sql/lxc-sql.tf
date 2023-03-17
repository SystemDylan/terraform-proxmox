# Proxmox LXC container resource
resource "proxmox_lxc" "mysql_container" {
  target_node = var.target_node # Suggestion: Add a variable for target_node
  vmid        = 120
  hostname    = "mysql-container"
  ostemplate  = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  cores       = 2
  memory      = 8192
  swap        = 8192
  password    = var.LXC_PASS
  onboot      = true
  start       = true
  ssh_public_keys = file("${path.module}/my_key.pub")

  # Network configuration
  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.container_ip}/24"
    gw     = var.gw_ip
  }

  # Root filesystem configuration
  rootfs {
    storage = "local"
    size    = "8G"
  }

  # Mountpoint for shared storage
  mountpoint {
    key     = "0"
    slot    = "0"
    storage = "${var.sharename}"
    volume  = "/mnt/pve/${var.sharename}"
    mp      = "/mnt/"
    size    = "30G"
  }

  # Ignore password changes in the container's lifecycle
  lifecycle {
    ignore_changes = [password]
  }

  # Provisioning using remote-exec to install and configure MySQL server
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update", # Update package index
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server", # Install MySQL server without prompts
      "sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf", # Allow remote connections
      "sudo systemctl restart mysql", # Restart MySQL service
      "sudo mysql -u root -p${var.MYSQL_PASS} -e \"CREATE USER 'root'@'%' IDENTIFIED BY '${var.MYSQL_PASS}';\"", # Create root user for remote connections
      "sudo mysql -u root -p${var.MYSQL_PASS} -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;\"", # Grant privileges to the remote root user
      "sudo mysql -u root -p${var.MYSQL_PASS} -e \"FLUSH PRIVILEGES;\"", # Reload privilege tables
      "sudo apt-get install -y python3-pip", # Install pip for Python 3
      "sudo pip3 install mysql-connector-python" # Install MySQL Connector/Python
    ]

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("${path.module}/my_key")
      host     = var.container_ip
    }
  }

  # Provisioning using the file provisioner to upload the create_table.py script
  provisioner "file" {
    source      = "${path.module}/create_table.py"
    destination = "/tmp/create_table.py"

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("${path.module}/my_key")
      host     = var.container_ip
    }
  }

  # Provisioning using remote-exec to run the create_table.py script
  provisioner "remote-exec" {
    inline = [
      "export MYSQL_HOST='mysql-container'",
      "export MYSQL_USER='root'",
            "export MYSQL_PASSWORD='${var.MYSQL_PASS}'",
      "python3 -v /tmp/create_table.py"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("${path.module}/my_key")
      host     = var.container_ip
    }
  }
}
