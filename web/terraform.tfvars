#aws_account_id = "4686-4719-2380"

aws_account_id = "345339357186"

web_asg_name = "web-asg"

web_ami           = "ami-04dd4500af104442f"
web_instance_type = "t2.nano"
web_keypair       = "dawn-test"

asg_max_size              = "4"
asg_min_size              = "1"
asg_wait_for_elb_capacity = "1"

all_cidr_blocks = "0.0.0.0/0"

vpc_subnet = "10.0.0.0/16"

private_subnets = "10.0.1.0/24"

public_subnets = "10.0.2.0/24"

description = "training"

vpc_name = "dawn-test"