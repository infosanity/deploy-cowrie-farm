resource "aws_iam_role" "ssm_managed_honeypot_role" {
  name               = "ssm_managed_honeypot_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ssm_managed_honeypot_profile" {
  name = "ssm_managed_honeypot_profile"
  role = aws_iam_role.ssm_managed_honeypot_role.name
}

resource "aws_iam_role_policy" "ssm_managed_honeypot_role_policy" {
  name   = "ssm_managed_honeypot_role_policy"
  role   = aws_iam_role.ssm_managed_honeypot_role.id
  policy = data.template_file.iam_instance_profile.rendered
  #policy = file("policy/ssm_instance_profile.json")

}