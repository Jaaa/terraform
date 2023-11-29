# VPC

# aws_vpc.this[0], aws_vpc.this[1], aws_vpc.this[2]

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0 # count = 0
  # false == true failed 0
  # true == true success , count = 5

  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = var.instance_tenancy
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_usage_metrics

  tags = var.vpc_tags
}

# Subnets - PUBLIC 

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr) # 0, 1 , 2, 3

  vpc_id                                         = aws_vpc.this[0].id #implicit dependencies
  availability_zone                              = var.azs[count.index]
  cidr_block                                     = var.public_subnet_cidr[count.index]
  enable_dns64                                   = var.public_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.public_enable_aaaa_record
  enable_resource_name_dns_a_record_on_launch    = var.public_enable_a_record
  map_public_ip_on_launch                        = var.public_map_on_launch
  # map_customer_owned_ip_on_launch = var.public_map_customer_owned_ip_on_launch
  # customer_owned_ipv4_pool = var.public_customer_owned_ipv4_pool

  tags = merge(
    var.public_subnet_tags,
    {
      Name = format("%s - %d", "Public Subnet", count.index + 1)
    }
  )
}

# Subnets - PRIVATE

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr) # 0, 1 , 2, 3

  vpc_id                                         = aws_vpc.this[0].id #implicit dependencies
  availability_zone                              = var.azs[count.index]
  cidr_block                                     = var.private_subnet_cidr[count.index]
  enable_dns64                                   = var.private_enable_dns64
  enable_resource_name_dns_aaaa_record_on_launch = var.private_enable_aaaa_record
  enable_resource_name_dns_a_record_on_launch    = var.private_enable_a_record
  map_public_ip_on_launch                        = var.private_map_ip_on_launch

  tags = merge(
    var.private_subnet_tags,
    {
      Name = format("%s - %d", "Private Subnet", count.index + 1)
    }
  )
}

# Internet Gateway

resource "aws_internet_gateway" "this" {
  count = var.create_vpc == true && length(var.public_subnet_cidr) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  tags   = var.igw_tags
}

/* Alternate way for creating IGW
resource "aws_internet_gateway" "this" {

}

resource "aws_internet_gateway_attachment" "name" {
  vpc_id = aws_vpc.this[0].id
  internet_gateway_id = aws_internet_gateway.this.id
}
*/

# Route Tables - Public
/*  Route tbale and routes are created in 1 go
resource "aws_route_table" "public" {
  vpc_id = ""

  route{

  }
}
*/
# aws_route_table.public[0]
resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidr) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  tags = {
    Name = "Public - RTB"
  }
}

resource "aws_route" "igw" {
  count = var.create_vpc == true && length(var.public_subnet_cidr) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id
  tags = {
    Name = "Private - RTB"
  }
}

# NAT GATEWAY
resource "aws_eip" "this" {
  count = var.create_ngw ? length(var.public_subnet_cidr) : 0
}

resource "aws_nat_gateway" "this" {
  count = var.create_ngw ? length(var.public_subnet_cidr) : 0

  subnet_id         = aws_subnet.public[count.index].id # 0, 1, 2
  connectivity_type = var.connectivity_type
  allocation_id     = var.connectivity_type == "public" ? aws_eip.this[count.index].id : ""

  tags = {}
}

/*
resource "aws_route" "ngw" {
 # count = var.create_vpc == true && length(var.private_subnet_cidr) > 0 ? 1 : 0

  route_table_id = aws_route_table.private[0].id
  destination_cidr_block = "170.0.0.0/28"
  nat_gateway_id = aws_nat_gateway.this[0].id
}
*/

# resource "aws_route" "name" {

# }

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}