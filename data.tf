data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "amaz2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["amazon"]
}

data "template_file" "cowrie_cfg" {
  template = file("${path.module}/cowrie_modifications/cowrie.cfg.tpl")
  vars = {
    hostname = "alpha-build-03"
  }
}

data "template_file" "iam_instance_profile" {
  template = file("${path.module}/policy/ssm_instance_profile.json.tpl")
  vars = {
    ssm_cowrie_cfg = aws_ssm_parameter.cowrie_cfg.arn
  }
}

data "template_file" "cowrie_install_script" {
  template = file("${path.module}/install_scripts/cowrie_install.tpl")
}