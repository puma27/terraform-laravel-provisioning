output "instance_label" {
  value = linode_instance.laravel_vm.label
}

output "instance_public_ip" {
  value = tolist(linode_instance.laravel_vm.ipv4)[0]
}

