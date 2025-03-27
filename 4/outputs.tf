output "vm_details" {
  description = "Details of the VM: instance_name, external_ip, fqdn"
  value = {
    instance_name = yandex_compute_instance.platform.name
    external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip
    fqdn          = "${yandex_compute_instance.platform.name}.example.com"  # Можно заменить на свой домен
  }
}
