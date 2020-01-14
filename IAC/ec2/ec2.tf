resource "aws_instance" "main" {
  ami                     = "${var.ami}"
  instance_type           = "${var.instance_type}"
  vpc_security_group_ids  = ["${var.security_groups}"]
  subnet_id               = "${var.subnets}"

  root_block_device {
    volume_size = "${var.root_disksize}"
  }
key_name = "${var.key_name}"
  tags = {
    BuiltBy = "terraform"
    Name = "${var.name}"

    }
  }
