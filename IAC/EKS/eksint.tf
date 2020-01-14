provider "aws" {
  region = "${var.region}"
}
resource "aws_eks_cluster" "integration_eks_cluster" {
  name     = "integration_eks_cluster"
  role_arn = "arn:aws:iam::564988778883:role/eks_default_service_role"
 # depends_on = ["aws_cloudwatch_log_group.sandbox2_subnet_flowlogs"]

  vpc_config {
    subnet_ids = ["${var.eks_subnet1}", "${var.eks_subnet2}"]
    endpoint_private_access = "true"
    endpoint_public_access = "false"
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.integration_eks_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.integration_eks_cluster.certificate_authority.0.data}"
}
