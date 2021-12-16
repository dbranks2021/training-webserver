data "aws_iam_policy_document" "assume_web_role" {
  statement {
    effect = "Allow"

    actions = [
    "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
      "ec2.amazonaws.com"]
    }


  }
}


resource "aws_iam_role" "web_role" {
  name               = "web_role"
  assume_role_policy = data.aws_iam_policy_document.assume_web_role.json
}


resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "web-role-profile"
  role = aws_iam_role.web_role.name
}

