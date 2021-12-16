resource "aws_instance" "bastion" {
  ami                         = var.web_ami
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "dawn-test"
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets
  security_groups             = [data.terraform_remote_state.vpc.outputs.default_security_group_id]
}