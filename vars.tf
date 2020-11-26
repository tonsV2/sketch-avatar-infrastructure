variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.1.0.0/16"
}
/*
variable "cidr_block_subnet_public" {
  default = "10.1.1.0/24"
}
*/
variable "cidr_block_subnets_private" {
  default = ["10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "database_engine" {
  default = "mariadb"
}

variable "database_engine_version" {
  default = "10.5"
}

variable "database_port" {
  default = 3306
}
