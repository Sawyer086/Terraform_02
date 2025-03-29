### 2 zadanie (Объединённые ресурсы ВМ)
variable "vms_resources" {
  type = map(object({
    platform_id   = string
    zone          = string
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))
  default = {
    "platform" = {
      platform_id   = "standard-v3"
      zone          = "ru-central1-a"
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      nat           = true
    }
    "platform_db" = {
      platform_id   = "standard-v3"
      zone          = "ru-central1-b"
      cores         = 2
      memory        = 2
      core_fraction = 20
      preemptible   = true
      nat           = true
    }
  }
}

### Общая переменная для metadata
variable "metadata_vars" {
  type = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFixQNdztt2dA4n2WlRR+UMCnV0mTSljuU366FJQHl2I sergey@Ubuntu"
  }
}

# Закомментированы более не используемые переменные:
# variable "vm_web_cores" {...}
# variable "vm_web_memory" {...}
# variable "vm_web_core_fraction" {...}
# variable "vm_web_preemptible" {...}
# variable "vm_web_nat" {...}
# variable "vm_web_serial_port_enable" {...}
# variable "vm_db_cores" {...}
# variable "vm_db_memory" {...}
# variable "vm_db_core_fraction" {...}
# variable "vm_db_preemptible" {...}
# variable "vm_db_nat" {...}
# variable "vm_db_serial_port_enable" {...}
