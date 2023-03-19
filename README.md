# Terraform Proxmox

A collection of Terraform templates for deploying various Proxmox resources.
Python and Shell scripting are used for environment management where Terraform cannot.

This repository contains Terraform configuration examples for:

- A simple LXC container instance, defining mountpoints and basic network configurations.
- An LXC container instance with more complex setup options, such as using the 'remote-exec' Terraform provisioner to run shell commands and a Python script on startup.
- A Python script which uses the 'mysql.connector' library to connect to a MySQL database, create a table, and populate it with data.

## Future Additions
More Proxmox configurations and use cases will be added.

