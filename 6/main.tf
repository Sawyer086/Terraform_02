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
  family = var.vm_web_family
}

# Первая ВМ (platform)
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_lname
  platform_id = var.vms_resources["platform"].platform_id
  zone        = var.vms_resources["platform"].zone

  resources {
    cores         = var.vms_resources["platform"].cores
    memory        = var.vms_resources["platform"].memory
    core_fraction = var.vms_resources["platform"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vms_resources["platform"].preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vms_resources["platform"].nat
  }

  metadata = var.metadata_vars
}

# Вторая ВМ (platform_db)
resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = var.vms_resources["platform_db"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.second_cidr
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_lname
  platform_id = var.vms_resources["platform_db"].platform_id
  zone        = var.vms_resources["platform_db"].zone

  resources {
    cores         = var.vms_resources["platform_db"].cores
    memory        = var.vms_resources["platform_db"].memory
    core_fraction = var.vms_resources["platform_db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vms_resources["platform_db"].preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = var.vms_resources["platform_db"].nat
  }

  metadata = var.metadata_vars
}
