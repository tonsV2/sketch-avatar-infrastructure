variable "database_engine" {
  default = "mariadb"
}

variable "database_engine_version" {
  default = "10.5"
}

variable "database_port" {
  default = 3306
}

variable "max_connections" {
  default = 80
}

variable "instance_class" {
  default = "db.t2.micro"
}
