#---------------------------------------------------------------
# Web Autoscaling Group
#---------------------------------------------------------------
resource "aws_autoscaling_group" "web_asg" {
  name                  = var.web_asg_name
  vpc_zone_identifier   = [data.terraform_remote_state.vpc.outputs.private_subnets]
  max_size              = 4
  min_size              = 1
  wait_for_elb_capacity = 1
  health_check_type     = "ELB"
  load_balancers        = [aws_elb.web_elb.name]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }


  instance_refresh {
    strategy = "Rolling"
  }

}

resource "aws_autoscaling_policy" "agents-scale-up" {
  name = "agents-scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web_asg.name}"
}

resource "aws_autoscaling_policy" "agents-scale-down" {
  name = "agents-scale-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.web_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "memory-high" {
  alarm_name = "mem-util-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "System/Linux"
  period = "300"
  statistic = "Average"
  threshold = "80"
  alarm_description = "This metric monitors ec2 memory for high utilization on agent hosts"
  alarm_actions = [
    "${aws_autoscaling_policy.agents-scale-up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_asg.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory-low" {
  alarm_name = "mem-util-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "System/Linux"
  period = "300"
  statistic = "Average"
  threshold = "40"
  alarm_description = "This metric monitors ec2 memory for low utilization on agent hosts"
  alarm_actions = [
    "${aws_autoscaling_policy.agents-scale-down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_asg.name}"
  }
}


#---------------------------------------------------------------
# Web Autoscaling Launch Template
#---------------------------------------------------------------
resource "aws_launch_template" "web" {
  name          = "web"
  image_id      = var.web_ami
  instance_type = var.web_instance_type
  key_name      = var.web_keypair

  vpc_security_group_ids = [aws_security_group.all_web.id]
  user_data              = filebase64("${path.module}/templates/userdata.tpl")
  iam_instance_profile {
    name = aws_iam_instance_profile.web_instance_profile.id
  }

  lifecycle {
    create_before_destroy = true
  }

}

### Creating ELB
resource "aws_elb" "web_elb" {
  name            = "dawn-web"
  security_groups = ["${aws_security_group.elb-sg.id}"]
  subnets         = [data.terraform_remote_state.vpc.outputs.public_subnets]
  #  availability_zones = ["${data.aws_availability_zones.all.names}"]
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}
