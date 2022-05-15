# 01. define vpc
resource "aws_vpc" "c_rock_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "c_rock_vpc"
  }
}

# PUBLIC SUBNETS ------------------------
# 02. first public subnet
resource "aws_subnet" "c_rock_public_subnet1" {
  vpc_id     = aws_vpc.c_rock_vpc.id
  cidr_block = var.c_rock_public_subnet1_cidr

  tags = {
    Name = "c_rock_public_subnet1"
  }
}


# 03. second public subnet
resource "aws_subnet" "c_rock_public_subnet2" {
  vpc_id     = aws_vpc.c_rock_vpc.id
  cidr_block = var.c_rock_public_subnet2_cidr

  tags = {
    Name = "c_rock_public_subnet2"
  }
}

# PRIVATE SUBNETS ------------------------
# 04. first private subnet
resource "aws_subnet" "c_rock_private_subnet1" {
  vpc_id     = aws_vpc.c_rock_vpc.id
  cidr_block = var.c_rock_private_subnet1_cidr

  tags = {
    Name = "c_rock_private_subnet1"
  }
}

# 05. second private subnet
resource "aws_subnet" "c_rock_private_subnet2" {
  vpc_id     = aws_vpc.c_rock_vpc.id
  cidr_block = var.c_rock_private_subnet2_cidr

  tags = {
    Name = "c_rock_private_subne2"
  }
}

# ROUTE TABLES ------------------------
# 06. public route table
resource "aws_route_table" "c_rock_public_route_tbl" {
  vpc_id = aws_vpc.c_rock_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.c_rock_igw.id
  }

  tags = {
    Name = "c_rock_public_route_tbl"
  }
}


# 07. private route table
resource "aws_route_table" "c_rock_private_route_tbl" {
  vpc_id = aws_vpc.c_rock_vpc.id

  tags = {
    Name = "c_rock_private_route_tbl"
  }
}

# PUBLIC ROUTE TABLE ASSOCIATIONS--------------------------
# 08. associate first public subnets to public route table
resource "aws_route_table_association" "c_rock_pub_subnet_assoc_pub_rt1" {
  subnet_id      = aws_subnet.c_rock_public_subnet1.id
  route_table_id = aws_route_table.c_rock_public_route_tbl.id
}

# 09. associate first public subnets to public route table
resource "aws_route_table_association" "c_rock_pub_subnet_assoc_pub_rt2" {
  subnet_id      = aws_subnet.c_rock_public_subnet2.id
  route_table_id = aws_route_table.c_rock_public_route_tbl.id
}

# PRIVATE ROUTE TABLE ASSOCIATIONS---------------------
# 10. associate first private subnets to public route table
resource "aws_route_table_association" "c_rock_priv_subnet_assoc_priv_rt1" {
  subnet_id      = aws_subnet.c_rock_private_subnet1.id
  route_table_id = aws_route_table.c_rock_private_route_tbl.id
}

# 11. associate second private subnets to public route table
resource "aws_route_table_association" "c_rock_priv_subnet_assoc_priv_rt2" {
  subnet_id      = aws_subnet.c_rock_private_subnet2.id
  route_table_id = aws_route_table.c_rock_private_route_tbl.id
}


# INTERNET GATEWAY---------------------
resource "aws_internet_gateway" "c_rock_igw" {
  vpc_id = aws_vpc.c_rock_vpc.id

  tags = {
    Name = "c_rock_igw"
  }
}


