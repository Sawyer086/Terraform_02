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

# Общая map-переменная для ресурсов ВМ
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
}

# Общая map-переменная для metadata
variable "vms_metadata" {
  type = map(string)
}

# Первая ВМ (уже существует)
resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_lname 
  platform_id = var.vm_web_platform_id
  zone        = var.default_zone  # Зона для первой ВМ

  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
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

  metadata = var.vms_metadata
}

# Вторая ВМ, созданная в зоне ru-central1-b
resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.second_cidr  # Добавьте новый диапазон IP
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_db_lname
  zone        = "ru-central1-b"  # Прямо указываем зону для второй ВМ
  platform_id = var.vm_db_platform_id

  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = var.vm_db_nat
  }

  metadata = var.vms_metadata
}

# Убираем неиспользуемые переменные (закомментированы)
# variable "vm_web_cores" {}
# variable "vm_web_memory" {}
# variable "vm_web_core_fraction" {}

# variable "vm_db_cores" {}
# variable "vm_db_memory" {}
# variable "vm_db_core_fraction" {}

# variable "vm_db_serial_port_enable" {}
