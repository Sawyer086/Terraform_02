variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex compute image family"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "yandex compute instance name"
}

variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "yandex compute instance zone"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "yandex compute instance platform id"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "yandex compute instance resources cores"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "yandex compute instance resources memory"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "yandex compute instance resources core-fraction"
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "yandex compute instance scheduling policy preemptible"
}

variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "yandex compute instance network interface nat"
}

variable "vm_db_serial_port_enable" {
  type        = number
  default     = 1
  description = "yandex compute instance metadata serial-port-enable"
}
