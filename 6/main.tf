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

# Новая map(object) переменная для ресурсов ВМ
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = optional(bool)
    nat           = optional(bool)
  }))
}

# Общий metadata блок
variable "metadata_common" {
  type = map(string)
}

# Первая ВМ (уже существует)
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_lname 
  platform_id = var.vm_web_platform_id
  zone        = var.default_zone  # Зона для первой ВМ

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

  metadata = var.metadata_common
}

# Вторая ВМ, созданная в зоне ru-central1-b
resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.second_cidr  # Добавлен новый диапазон IP
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_lname
  zone        = "ru-central1-b"  # Прямо указываем зону для второй ВМ
  platform_id = var.vm_db_platform_id

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

  metadata = var.metadata_common
}

# Закомментированные переменные, которые больше не используются
# variable "vm_web_cores" {}
# variable "vm_web_memory" {}
# variable "vm_web_core_fraction" {}
# variable "vm_db_cores" {}
# variable "vm_db_memory" {}
# variable "vm_db_core_fraction" {}
# variable "vm_db_preemptible" {}
# variable "vm_db_nat" {}
# variable "vm_db_serial_port_enable" {}

# Пример значений для новых переменных
variable "vms_resources" {
  default = {
    platform = {
      cores         = 2
      memory        = 4
      core_fraction = 50
      preemptible   = true
      nat           = true
    }
    platform_db = {
      cores         = 4
      memory        = 8
      core_fraction = 20
      preemptible   = false
      nat           = false
    }
  }
}

variable "metadata_common" {
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
