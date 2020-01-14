variable "region" {
  default = "us-east-1"
}

variable "eks_subnet1" {
  default = "subnet-0edbcdcfd7417c5b5"
  type    = "string"
}
variable "eks_subnet2" {
  default = "subnet-06ea7bcf40c0823d5"
  type    = "string"
}
variable "vpcId" {
  default = "vpc-09e7964bb913baa24"
  type    = "string"
}

