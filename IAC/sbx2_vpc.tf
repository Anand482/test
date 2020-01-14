provider "aws" {
  region = "us-east-1"
}

terraform {
 backend "s3" {
   bucket = "xcel-tf-sandbox2-state"
   key    = "terraform.tfstate"
   region = "us-east-1"
 }
}

#vpc
resource "aws_vpc" "sandbox2_vpc" {
    cidr_block ="10.240.160.0/19"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"

    tags = {
        Name = "sandbox2_vpc"
    }
}

#subnets
resource "aws_subnet" "sandbox2_subnet-1" {
    vpc_id = "${aws_vpc.sandbox2_vpc.id}"
    cidr_block = "10.240.160.0/21"
    availability_zone = "us-east-1a"

    tags = {
        Name = "sandbox2_1st_subnet"
    }
}

resource "aws_subnet" "sandbox2_subnet-2" {
    vpc_id = "${aws_vpc.sandbox2_vpc.id}"
    cidr_block = "10.240.168.0/21"
    availability_zone = "us-east-1b"
    tags = {
        Name = "sandbox2_2nd_subnet"
    }
}

resource "aws_subnet" "sandbox2_subnet-3" {
    vpc_id = "${aws_vpc.sandbox2_vpc.id}"
    cidr_block = "10.240.176.0/21"
    availability_zone = "us-east-1c"
    tags = {
        Name = "sandbox2_3rd_subnet"
    }
}

#route tables
resource "aws_ec2_transit_gateway_vpc_attachment" "sandbox2_tgw_attachment" {
  subnet_ids         = ["${aws_subnet.sandbox2_subnet-3.id}","${aws_subnet.sandbox2_subnet-2.id}","${aws_subnet.sandbox2_subnet-3.id}"]
  transit_gateway_id = "tgw-0432f7c5357b642ff"
  vpc_id             = "${aws_vpc.sandbox2_vpc.id}"

  tags = {
    Name = "sandbox2_tgw_attachment"
  }
}

#route tables
resource "aws_route_table" "sandbox2_routetable" {
    vpc_id = "${aws_vpc.sandbox2_vpc.id}"
    route {
      cidr_block = "0.0.0.0/0"
      transit_gateway_id = "tgw-0432f7c5357b642ff"
    }

    tags = {
        Name = "sandbox2_routetable"
    }
 }

#route associations public
resource "aws_route_table_association" "sandbox_rta-sub-1" {
    subnet_id = "${aws_subnet.sandbox2_subnet-1.id}"
    route_table_id = "${aws_route_table.sandbox2_routetable.id}"
  }

resource "aws_route_table_association" "sandbox_rta-sub-2" {
   subnet_id = "${aws_subnet.sandbox2_subnet-2.id}"
   route_table_id = "${aws_route_table.sandbox2_routetable.id}"
  }

resource "aws_route_table_association" "sandbox_rta-sub-3" {
   subnet_id = "${aws_subnet.sandbox2_subnet-3.id}"
   route_table_id = "${aws_route_table.sandbox2_routetable.id}"
  }

resource "aws_flow_log" "sandbox2_fl_subnet1" {
  iam_role_arn    = "${aws_iam_role.sandbox2_iam_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.sandbox2_flowlogs.arn}"
  traffic_type    = "ALL"
  subnet_id       = "${aws_subnet.sandbox2_subnet-1.id}"
}

resource "aws_flow_log" "sandbox2_fl_subnet2" {
  iam_role_arn    = "${aws_iam_role.sandbox2_iam_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.sandbox2_flowlogs.arn}"
  traffic_type    = "ALL"
  subnet_id       = "${aws_subnet.sandbox2_subnet-2.id}"
}

resource "aws_flow_log" "sandbox2_fl_subnet3" {
  iam_role_arn    = "${aws_iam_role.sandbox2_iam_role.arn}"
  log_destination = "${aws_cloudwatch_log_group.sandbox2_flowlogs.arn}"
  traffic_type    = "ALL"
  subnet_id       = "${aws_subnet.sandbox2_subnet-3.id}"
}

resource "aws_cloudwatch_log_group" "sandbox2_flowlogs" {
  name = "sandbox2_subnet_flowlogs"
}

resource "aws_iam_role" "sandbox2_iam_role" {
  name = "sandbox2_iam_role"

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

resource "aws_iam_role_policy" "sandbox2_iam_role_policy" {
  name = "sandbox2_iam_role_policy"
  role = "${aws_iam_role.sandbox2_iam_role.id}"

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

resource "aws_instance" "sandbox2_instance_1" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.sandbox2_subnet-1.id}"
  tags = {
    Name = "sandbox2_instance_1"
  }
}

resource "aws_instance" "sandbox2_instance_2" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.sandbox2_subnet-2.id}"
  tags = {
    Name = "sandbox2_instance_2"
  }
}

resource "aws_instance" "sandbox2_instance_3" {
  ami           = "ami-047aacf2d2174fc55"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.sandbox2_subnet-3.id}"
  tags = {
    Name = "sandbox2_instance_3"
  }
}
