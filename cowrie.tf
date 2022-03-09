variable "admin_ip" {
  default = "a.b.c.d"
}

variable "ssh_key_name" {
  default = "YourKeyNameHere"
}

data "template_file" "cowrie_user_data" {
  template = file("${path.module}/cowrie-install.sh")
}

resource "aws_security_group" "cowrie_honeypot_exposed" {
  name        = "Cowrie Honeypot Ports"
  description = "Public access to Cowrie honeypot port(s)"

  ingress {
    from_port   = 22 #mapped to default Cowrie SSH (T:2222) via iptables
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cowrieTF" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_managed_honeypot_profile.name

  tags = {
    Name = "CowrieViaTF"
  }

  key_name = aws_key_pair.cowrie_key.key_name

  vpc_security_group_ids = [
    "${aws_security_group.cowrie_honeypot_exposed.id}"
  ]

  user_data = data.template_file.cowrie_install_script.rendered
  lifecycle {
    ignore_changes = [user_data]
  }
}

output "Cowrie_IP" {
  value = aws_instance.cowrieTF.public_ip
}

output "Cowrie_HoneyPot_SSH" {
  value = "ssh testuser@${aws_instance.cowrieTF.public_ip}"
}
