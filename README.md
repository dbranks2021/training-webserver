# Terraform code to create vpc, webserver and bastion

Terraform version
-----------------

Use Terraform 0.14.11


Running
=======


Setting Up
----------
This project assumes that you are using an AWS profile, or running on an
EC2 instance with an appropriate instance profile. Ensure your
credentials are in `~/.aws/credentials`, and set the following
environment variables:

    AWS_PROFILE=my-terraform-profile
    AWS_DEFAULT_REGION=eu-west-1

Clone the repo
---------------

git clone git@github.com:dbranks2021/training-webserver.git

Create VPC
-----------------

$ cd training-webserver

$ terraform init

$ terraform plan -out plan.out

$ terraform apply

$ mv remote_state remote_state.tf

$ terraform init

Type yes to copy existing state to the new backend
     ---

Create webserver
-----------------
$ cd web

$ terraform init

$ terraform plan -out plan.out

$ terraform apply

Accessing the website
----------------------
The website can be accessed using the ELB address

i.e http://dawn-web-72908829.eu-west-1.elb.amazonaws.com/index.html

---------------------------------------------------------------------------------------
The Vpc is created with a cidr block of 10.0.0.0/16.

There two subnets, a private and public subnet.

An ASG is created with launch_template rather than a launch_config. This is so that mixed instance types can be used as well as spot instances.

CloudWatch metric alarms. There are two one, that triggers the scale up policy when the memory utilization is >= 80% for 2 5 minute intervals. The second one triggers the scale down policy when  overall memory utilization is <= 40%.

The elb is deployed in the public subnet. All incoming requests to the webserver will hit the loadbalancer first which
is in the public subnet, the loadbalancer will then direct requests to the webserver instances located in  the private
subnet.

Improvements
--------------
A domain needs to be registered and a route53 alias created that points to the ELB. 

i.e www.example.com A(alias) dawn-web-72908829.eu-west-1.elb.amazonaws.com

Create an SSL cert and apply it to the ELB so that access to the website is secure.


