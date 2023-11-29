resource "aws_security_group" "for_each" {
  description = var.sg_description
  name        = var.sg_name
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  type = "ingress" # each.value.type

  description = each.key             # SSH  HTTPS
  from_port   = each.value.from_port # 22    443    80
  to_port     = each.value.to_port   # 22    443    80
  protocol    = each.value.protocol  # tcp   tcp    tcp
  cidr_blocks = each.value.cidr_blocks

  security_group_id = aws_security_group.for_each.id
}

resource "aws_security_group_rule" "egress" {
  for_each = var.egress_rules

  type = "egress" # each.value.type

  description = each.key               # SSH  HTTPS
  from_port   = each.value.from_port   # 22    443    80
  to_port     = each.value.to_port     # 22    443    80
  protocol    = each.value.protocol    # tcp   tcp    tcp
  cidr_blocks = each.value.cidr_blocks # each.value["cidr_blocks"]

  security_group_id = aws_security_group.for_each.id
}



# resource "aws_security_group_rule" "egress" {

# }