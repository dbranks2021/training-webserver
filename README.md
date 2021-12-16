# Terraform code to create vpc, webserver and bastion

The code requires terraform version 0.14.11 and above.

The Vpc is created with a cidr blcok of 10.0.0.0/16.

There two subnets, a private and public subnet.

An ASG is created with launch_template rather than a launch_config. This is so that mixed instance types can be used as well as spot instances.

CloudWatch metric alarms. There are two one that triggers the scale up policy when the memory utilization is >= 80% for 2 5 minute intervals. The second one triggers the scale down policy when  overall memory utilization is <= 40%.

The elb is deployed in the public subnet. All incoming requests to the webserver will hit the loadbalancer first which
is in the public subnet, the loadbalancer will then direct requests to the webserver instances located in  the private
subnet.
