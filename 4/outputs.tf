output "vm_instances" {
  value = {
    platform = {
      instance_name = yandex_compute_instance.platform.name
      external_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn          = "${yandex_compute_instance.platform.name}.auto.internal"
    }
    platform_db = {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip   = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
      fqdn          = "${yandex_compute_instance.platform_db.name}.auto.internal"
    }
  }
  description = "Информация о виртуальных машинах"
}
