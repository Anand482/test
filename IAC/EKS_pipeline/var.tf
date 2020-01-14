
variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

variable "eks_subnet1" {
  default = "subnet-06ea7bcf40c0823d5"
  type    = "string"
}
variable "eks_subnet2" {
  default = "subnet-0bd128c307f14c1c4"
  type    = "string"
}
variable "vpcId" {
  default = "vpc-09e7964bb913baa24"
  type    = "string"
}
