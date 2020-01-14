resource "aws_db_instance" "myrds" {
  allocated_storage    = "${var.storage}"
 # storage_type         = "gp2"
  engine               = "${var.engine}"
  engine_version       = "${lookup(var.engine_version, var.engine)}"
 # cluster_family       = "aurora-postgresql9.6"
  instance_class       = "db.r4.large"
  name                 = "mydb"
  username             = "balaji"
  password             = "balai123"
  #parameter_group_name = "default"
  final_snapshot_identifier = "thisisfinal"
  db_subnet_group_name        = "${aws_db_subnet_group.rds-private-subnet1.name}"
  vpc_security_group_ids      = ["${aws_security_group.rds-sg1.id}"]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  #multi_az                    = true
 # skip_final_snapshot         = true
}
resource "aws_security_group" "rds-sg1" {
  name   = "my-rds-sg"
  vpc_id = "${var.vpc_id}"

}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rds-sg1.id}"
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_db_subnet_group" "rds-private-subnet1" {
  name = "rds-private-subnet-group"
  subnet_ids = ["${var.rds_subnet1}","${var.rds_subnet2}"]
}
~
