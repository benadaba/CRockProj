# 01.  create vpc
resource "aws_vpc" "crock_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "crock_vpc"
  }
}


# PUBLIC SUBNETS ----------------------------------
# 02. 1st public subnet
resource "aws_subnet" "prod-pub-sub1" {
  vpc_id     = aws_vpc.crock_vpc.id
  cidr_block = var.prod-pub-sub1_cidr

  tags = {
    Name = "Prod Public Subnet 1"
  }
}

# 03. 2nd public subnet
resource "aws_subnet" "prod-pub-sub2" {
  vpc_id     = aws_vpc.crock_vpc.id
  cidr_block = var.prod-pub-sub2_cidr

  tags = {
    Name = "Prod Public Subnet 2"
  }
}


# 04. 3rd public subnet
resource "aws_subnet" "prod-pub-sub3" {
  vpc_id     = aws_vpc.crock_vpc.id
  cidr_block = var.prod-pub-sub3_cidr

  tags = {
    Name = "Prod Public Subnet 3"
  }
}



# PRIVATE SUBNETS ----------------------------------
# 05. 1st private subnet
resource "aws_subnet" "prod-priv-sub1" {
  vpc_id     = aws_vpc.crock_vpc.id
  cidr_block = var.prod-priv-sub1_cidr

  tags = {
    Name = "Prod Private Subnet 1"
  }
}


# 06. 2nd private subnet
resource "aws_subnet" "prod-priv-sub2" {
  vpc_id     = aws_vpc.crock_vpc.id
  cidr_block = var.prod-priv-sub2_cidr

  tags = {
    Name = "Prod Private Subnet 2"
  }
}



# PUBLIC ROUTE TABLE ----------------------------------
# 07. public route table
resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.crock_vpc.id

  route {
    cidr_block = var.prod-igw_cidr
    gateway_id = aws_internet_gateway.prod-igw.id
  }

  tags = {
    Name = "public route table"
  }
}


# INTERNTE GATEWAY -------
# 08. Internet gateway
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.crock_vpc.id

  tags = {
    Name = "internet gateway - Prod-igw"
  }
}



# PRIVATE ROUTE TABLE ----------------------------------
# 09. public route table
resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.crock_vpc.id

  tags = {
    Name = "prod-priv-route-table"
  }
}



# PUBLIC ROUTE TABLE and PUBLIC SUBNETS ASSOICATIONS ------------------
# 10. 1st public subnet route table association
resource "aws_route_table_association" "prod-pub-sub1_rt_assocation" {
  subnet_id      = aws_subnet.prod-pub-sub1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


# 11. 2nd public subnet route table association
resource "aws_route_table_association" "prod-pub-sub2_rt_assocation" {
  subnet_id      = aws_subnet.prod-pub-sub2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


# 12. 3rd public subnet route table association
resource "aws_route_table_association" "prod-pub-sub3_rt_assocation" {
  subnet_id      = aws_subnet.prod-pub-sub3.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


# PRIVATE SUBNETS and PRIVATE ROUTE TABLE ASSOCIATIONS ----------------------------------------
# 13. 1st private subnet route table association
resource "aws_route_table_association" "prod-priv-sub1_rt_assocation" {
  subnet_id      = aws_subnet.prod-priv-sub1.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}


# 14. 2nd private subnet route table association
resource "aws_route_table_association" "prod-priv-sub2_rt_assocation" {
  subnet_id      = aws_subnet.prod-priv-sub2.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}


# 15. NAT Gateway
resource "aws_nat_gateway" "prod-nat-gateway" {
  #allocation_id = aws_eip.prod_iep.id
  connectivity_type = "private"
  subnet_id         = aws_subnet.prod-pub-sub1.id

  tags = {
    Name = "prod-nat-gateway"
  }
}

/* # 16. EIP
resource "aws_eip" "prod_iep" {
  vpc = true
  tags = {
    Name = "${var.service_name}-eip"
  }
} */


# 17. Associate NAT gateway with PRIVATE ROUTE TABLE
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.prod-priv-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.prod-nat-gateway.id
}


