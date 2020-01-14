provider "aws" {
  region = "us-east-1"
}

terraform {
 backend "s3" {
   bucket = "xcel-tf-sbx2-pipeline-state"
   key    = "terraform.tfstate"
   region = "us-east-1"
 }
}

#vpc
resource "aws_vpc" "sbx2_pipeline_vpc" {
    cidr_block ="10.240.64.0/20"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"

    tags = {
        Name = "sbx2_pipeline_vpc"
    }
}

#subnets
resource "aws_subnet" "sbx2_pipeline_subnet-1" {
    vpc_id = "${aws_vpc.sbx2_pipeline_vpc.id}"
    cidr_block = "10.240.64.0/22"
    availability_zone = "us-east-1a"

    tags = {
        Name = "sbx2_pipeline_1st_subnet"
    }
}

resource "aws_subnet" "sbx2_pipeline_subnet-2" {
    vpc_id = "${aws_vpc.sbx2_pipeline_vpc.id}"
    cidr_block = "10.240.72.0/22"
    availability_zone = "us-east-1b"
    tags = {
        Name = "sbx2_pipeline_2nd_subnet"
    }
}

resource "aws_subnet" "sbx2_pipeline_subnet-3" {
    vpc_id = "${aws_vpc.sbx2_pipeline_vpc.id}"
    cidr_block = "10.240.79.0/22"
    availability_zone = "us-east-1c"
    tags = {
        Name = "sbx2_pipeline_3rd_subnet"
    }
}

# #route tables
# resource "aws_ec2_transit_gateway_vpc_attachment" "sbx2_pipeline_tgw_attachment" {
#   subnet_ids         = ["${aws_subnet.sbx2_pipeline_subnet-3.id}","${aws_subnet.sbx2_pipeline_subnet-2.id}","${aws_subnet.sbx2_pipeline_subnet-3.id}"]
#   transit_gateway_id = "tgw-0432f7c5357b642ff"
#   vpc_id             = "${aws_vpc.sbx2_pipeline_vpc.id}"
#
#   tags = {
#     Name = "sbx2_pipeline_tgw_attachment"
#   }
# }

# #route tables
# resource "aws_route_table" "sbx2_pipeline_routetable" {
#     vpc_id = "${aws_vpc.sbx2_pipeline_vpc.id}"
#     route {
#       cidr_block = "0.0.0.0/0"
#       transit_gateway_id = "tgw-0432f7c5357b642ff"
#     }
#
#     tags = {
#         Name = "sbx2_pipeline_routetable"
#     }
#  }
#
# #route associations public
# resource "aws_route_table_association" "sandbox_rta-sub-1" {
#     subnet_id = "${aws_subnet.sbx2_pipeline_subnet-1.id}"
#     route_table_id = "${aws_route_table.sbx2_pipeline_routetable.id}"
#   }
#
# resource "aws_route_table_association" "sandbox_rta-sub-2" {
#    subnet_id = "${aws_subnet.sbx2_pipeline_subnet-2.id}"
#    route_table_id = "${aws_route_table.sbx2_pipeline_routetable.id}"
#   }
#
# resource "aws_route_table_association" "sandbox_rta-sub-3" {
#    subnet_id = "${aws_subnet.sbx2_pipeline_subnet-3.id}"
#    route_table_id = "${aws_route_table.sbx2_pipeline_routetable.id}"
#   }

resource "aws_flow_log" "sbx2_pipeline_fl_subnet1" {
  iam_role_arn    = "${aws_iam_role.sbx2_pipeline_iam_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.sbx2_pipeline_flowlogs.arn}"
  traffic_type    = "ALL"
  subnet_id       = "${aws_subnet.sbx2_pipeline_subnet-1.id}"
}

resource "aws_flow_log" "sbx2_pipeline_fl_subnet2" {
  iam_role_arn    = "${aws_iam_role.sbx2_pipeline_iam_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.sbx2_pipeline_flowlogs.arn}"
  traffic_type    = "ALL"
  subnet_id       = "${aws_subnet.sbx2_pipeline_subnet-2.id}"
}

resource "aws_flow_log" "sbx2_pipeline_fl_subnet3" {
  iam_role_arn    = "${aws_iam_role.sbx2_pipeline_iam_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.sbx2_pipeline_flowlogs.arn}"
  traffic_type    = "ALL"
  subnet_id       = "${aws_subnet.sbx2_pipeline_subnet-3.id}"
}

resource "aws_cloudwatch_log_group" "sbx2_pipeline_flowlogs" {
  name = "sbx2_pipeline_subnet_flowlogs"
}

resource "aws_iam_role" "sbx2_pipeline_iam_role" {
  name = "sbx2_pipeline_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sbx2_pipeline_iam_role_policy" {
  name = "sbx2_pipeline_iam_role_policy"
  role = "${aws_iam_role.sbx2_pipeline_iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "sbx2_pipeline_instance_1" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.sbx2_pipeline_subnet-1.id}"
  tags = {
    Name = "sbx2_pipeline_instance_1"
  }
}

resource "aws_instance" "sbx2_pipeline_instance_2" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.sbx2_pipeline_subnet-2.id}"
  tags = {
    Name = "sbx2_pipeline_instance_2"
  }
}

resource "aws_instance" "sbx2_pipeline_instance_3" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.sbx2_pipeline_subnet-3.id}"
  tags = {
    Name = "sbx2_pipeline_instance_3"
  }
}

resource "aws_instance" "sbx2_pipeline_instance_4" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.medium"
  subnet_id     = "${aws_subnet.sbx2_pipeline_subnet-3.id}"
  tags = {
    Name = "sbx2_pipeline_instance_4"
  }
}

resource "aws_eks_cluster" "pipeline_eks_cluster" {
  name     = "pipeline_eks_cluster"
  role_arn = "arn:aws:iam::564988778883:role/eks_default_service_role"
  depends_on = ["aws_cloudwatch_log_group.sbx2_pipeline_flowlogs"]

  vpc_config {
    subnet_ids = ["${aws_subnet.sbx2_pipeline_subnet-1.id}", "${aws_subnet.sbx2_pipeline_subnet-2.id}", "${aws_subnet.sbx2_pipeline_subnet-3.id}"]
    security_group_ids = ["sg-0283fc89e6f58660b"]
    endpoint_private_access = "true"
    endpoint_public_access = "false"
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.pipeline_eks_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.pipeline_eks_cluster.certificate_authority.0.data}"
}
