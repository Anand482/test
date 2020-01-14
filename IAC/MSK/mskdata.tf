provider "aws" {
   region = "us-east-1"
}

resource "aws_security_group" "sg" {
  vpc_id = var.vpcId
}

resource "aws_kms_key" "kms" {
  description = "msk kms"
}

resource "aws_msk_cluster" "example" {
  cluster_name = "kafka-data-sbx3" 
  kafka_version = "2.2.1"
  number_of_broker_nodes = 1
  
  broker_node_group_info {
    instance_type = "kafka.m5.large" 
    ebs_volume_siz = "1000"
    client_subnets = [   
     var.msk_subnet1,
     var.msk_subnet2,
     var.msk_subnet3
    ]
    security_groups = [ "${aws-security_group.sg.id}" ]
   }
  
   encryption_info {
     encryption_at_rest_kms_key_arn = "${aws_kms_key.kms.arn}"
   }
 
   tags = {
     name = "mymsk" 
   }
 }

output "zookeeper_connect_string" {
  value = "${aws_msk_clusterexample.zookeper_connect_string}"
}

output bootstrap_brokers" { 
  description = "plaintext connection host:port pairs" 
  value       = "${aws_msk_cluster.example.bootstrap_brokers}"
}

output "bootstrap_broker_tls" {
   description = "TLS connection host:port pairs"
   value 
