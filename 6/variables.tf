### Переменная для ресурсов ВМ
variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
      preemptible   = true
      nat           = true
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
      preemptible   = true
      nat           = true
    }
  }
}

### Переменная для metadata (общая)
variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

### Закомментированные переменные, которые больше не используются
# variable "vm_web_cores" {}
# variable "vm_web_memory" {}
# variable "vm_web_core_fraction" {}
# variable "vm_db_cores" {}
# variable "vm_db_memory" {}
# variable "vm_db_core_fraction" {}
# variable "vm_db_serial_port_enable" {}
# variable "vm_web_serial_port_enable" {}
# variable "vm_web_preemptible" {}
# variable "vm_web_nat" {}
# variable "vm_db_preemptible" {}
# variable "vm_db_nat" {}
