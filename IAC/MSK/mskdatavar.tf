variable "cluster-name" {
  default = "our-mks"
  type    = string
}

variable "msk_subnet1" {
  default = "subnet-0edbcdcfd7417c5b5"
  type    = string
}

variable "msk_subnet2" {
  default = "subnet-06ea7bcf40c0823d5"
  type    = string
}

variable "msk_subnet3" {
  default = "subnet-0bd128c307f14c1c4"
  type    = string
}


variable "vpcId" {
  default = "vpc-09e7964bb913baa24"
  type    = string
}
