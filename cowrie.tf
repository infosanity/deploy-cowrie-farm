provider "aws"{
    region                  = "eu-west-1"
    shared_credentials_file = "/home/awaite/.aws/credentials"
    profile                 = "IS-HP-full"
}

variable "admin_ip"{
    default = "a.b.c.d"
}

variable "ssh_key_name"{
    default = "YourKeyNameHere"
}

data "template_file" "cowrie_user_data" {
    template = "${file("${path.module}/cowrie-install.sh")}"
}

resource "aws_security_group" "allow_becl46" {
    name = "Allow BECL46 Admin"
    description = "Allow Admin"
    ingress {
        from_port = 22222
        to_port = 22222
        protocol = "tcp"
        cidr_blocks = [var.admin_ip]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "cowrie_honeypot_exposed" {
    name = "Cowrie Honeypot Ports"
    description = "Public access to Cowrie honeypot port(s)"

    ingress {
        from_port = 22 #mapped to default Cowrie SSH (T:2222) via iptables
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "CowrieTFWIP" {
    ami = "ami-02df9ea15c1778c9c" #Ubuntu 18.04 LTS
    instance_type = "t3.micro"

    tags = {
        Name = "CowrieViaTF"
    }

    key_name = "HP-default"

    vpc_security_group_ids = [  "${aws_security_group.allow_becl46.id}",
                                "${aws_security_group.cowrie_honeypot_exposed.id}"
    ]

    user_data = "${data.template_file.cowrie_user_data.rendered}"
}

output "Cowrie_IP" {
  value = ["${aws_instance.CowrieTFWIP.public_ip}"]
}

output "Cowrie_Admin_SSH" {
    value = "ssh -i HP-default.pem -p 22222 ubuntu@${aws_instance.CowrieTFWIP.public_ip}"
}

output "Cowrie_HoneyPot_SSH" {
    value = "ssh testuser@${aws_instance.CowrieTFWIP.public_ip}"
}