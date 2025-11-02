resource "linode_instance" "laravel_vm" {
  label     = "${var.username}_test_cloudops_${formatdate("YYYY-MM-DD", timestamp())}"
  image     = "linode/ubuntu22.04"
  region    = var.region
  type      = "g6-standard-2"
  root_pass = var.root_password

  provisioner "file" {
    source      = "scripts/install_laravel.sh"
    destination = "/root/install_laravel.sh"

    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host = tolist(self.ipv4)[0]
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/install_laravel.sh",
      "bash /root/install_laravel.sh"
    ]

    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host = tolist(self.ipv4)[0]
    }
  }
}
