resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
#  family = "ubuntu-2004-lts"
# 2 zadanie
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v3"
# 2 zadanie
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}


### 3 zadanie

resource "yandex_vpc_network" "develop2" {
  name = var.vm_db_name
}
resource "yandex_vpc_subnet" "develop3" {
  name           = var.vm_db_name
  zone           = var.vm_db_default_zone
  network_id     = yandex_vpc_network.develop2.id
  v4_cidr_blocks = var.vm_db_default_cidr
}


data "yandex_compute_image" "ubuntu2" {
  family = var.vm_web_family
}

resource "yandex_compute_instance" "netology-develop" {
  name        = "netology-develop-platform-web2"
  platform_id = "standard-v3"
  zone        = var.vm_db_default_zone

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu2.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop3.id
    nat       = true
  }

#  /*metadata = {
#    serial-port-enable = 1
#    ssh-keys           = "ubuntu:${var.vm_db_ssh_root_key}"
#  }*/

  metadata = var.vms_ssh_root_key

