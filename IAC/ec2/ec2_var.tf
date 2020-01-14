#an AMI is an amazon machine image
variable "ami" {
  default = "ami-047aacf2d2174fc55"
}


variable "instance_type" {
#  default = "t2.micro"
}

variable "security_groups" {
  default = "sg-0beb944991362af03"
}

variable "vpc" {
  default = "vpc-09e7964bb913baa24"
}

variable "subnets" {
  default = "subnet-0edbcdcfd7417c5b5"
}

variable "name" {
  default = "nihar"
}

variable "key_name" {
  default = "nihar_new"
}

variable "root_disksize" {
  default = "30"
}

output "instance_type" {
description = "list of instance types"
value   = aws_instance.main.id
}
