variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"

  default = {
    mysql    = "5.7.21"
    postgres = "9.6.8"
  }
}


variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Id of the  VPC"
  default     = "vpc-0a698d030f6f8d02a"
}

variable "rds_subnet1" {
  description = "subnet of the  VPC"
  default     = "subnet-025aa61eadd36826a"
}
variable "rds_subnet2" {
  description = "subnet of the  VPC"
  default     = "subnet-06cdef1879693c113"
}
variable "storage" {
  default     = "10"
  description = "Storage size in GB"
}

