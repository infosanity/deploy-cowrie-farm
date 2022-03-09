resource "aws_ssm_parameter" "cowrie_cfg" {
  name  = "/honeypot/cowrie/cowrie.cfg"
  type  = "String"
  value = data.template_file.cowrie_cfg.rendered
}