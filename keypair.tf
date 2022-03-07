resource "tls_private_key" "cowrie_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cowrie_key" {
  key_name   = "cowrie"
  public_key = tls_private_key.cowrie_key.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.cowrie_key.private_key_pem
  sensitive = true
}