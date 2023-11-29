module "networking" {
  source = "../modules/aws_networking"

  create_vpc                   = true
  vpc_cidr                     = "170.0.0.0/16"
  enable_network_usage_metrics = true

  vpc_tags = {
    Name         = "Terraform Training"
    Batch        = "November 2023"
    Resouce_Type = "Network"
  }

  # Public subnets
  public_subnet_cidr = ["170.0.0.0/28", "170.0.0.16/28", "170.0.0.32/28"]
  # 0                #1               # 2
  azs                  = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_map_on_launch = true
  public_subnet_tags = {
    Type  = "Public"
    Owner = "Gokul"
  }

  # Private Subnets
  private_subnet_cidr      = ["170.0.0.48/28", "170.0.0.64/28"]
  private_map_ip_on_launch = false
  private_subnet_tags = {
    Type  = "Private"
    Owner = "Gokul"
  }
  igw_tags = {
    Name = "Terraform Training"
  }

  create_ngw        = false
  connectivity_type = "public"
}

module "security_group" {
  source = "../modules/aws_security_group"

  sg_description = "This is SG using FOR_EACH"
  sg_name        = "for_each"
  vpc_id         = module.networking.vpc_id

  ingress_rules = {
    "SSH" = {
      # description = "this is my SSH connection"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["170.0.0.0/16"]
    },
    "HTTPS" = {
      #  description = "this is my HTTPS connection"
      # type = ingress
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["170.0.0.0/16"]
    },
    "HTTP" = {
      #  description = "this is my HTTP connection"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["170.0.0.0/16"]
    }
  }
  egress_rules = {
    "ALLOW_ALL" = {
      #  description = "this is my HTTP connection"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "sg_names" {
  description = ""
  type        = list(string)
  default     = ["Monday", "Tuesday", "Wednesday"]
  # 0         # 1        # 2
}

resource "aws_security_group" "name" {
  count = length(var.sg_names)

  name = var.sg_names[count.index]
}

