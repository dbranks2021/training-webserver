variable "aws_account_id" {}

variable "region" {
  description = "AWS region for hosting our your network"
  default     = "eu-west-1"
}
variable "key_name" {
  description = "Key name for SSHing into EC2"
  default     = "dawn-test"
}
variable "web_asg_name" {
  description = "ASG name"
}

variable "web_ami" {}
variable "web_instance_type" {}
variable "web_keypair" {}

variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_wait_for_elb_capacity" {}
variable "all_cidr_blocks" {}

variable "vpc_subnet" {}

variable "private_subnets" {}

variable "public_subnets" {}

variable "vpc_name" {}

variable "description" {}
