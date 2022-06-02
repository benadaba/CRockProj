#01.  create vpc
resource "aws_vpc" "prod-rock-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod-rock-vpc"
  }
}

# PUBLIC SUBNETS ---------------------
#02.  1st public subnet
resource "aws_subnet" "test-public-sub1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.test-public-sub1
  map_public_ip_on_launch = true
  availability_zone = var.eu-west-2a-az

  tags = {
    Name = "test-public-sub1"
  }
}

#03.  2nd public subnet
resource "aws_subnet" "test-public-sub2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.test-public-sub2
  map_public_ip_on_launch = true
  availability_zone = var.eu-west-2b-az

  tags = {
    Name = "test-public-sub2"
  }
}



# PRIVATE SUBNETS ---------------------
#04.  1st private subnet
resource "aws_subnet" "test-priv-sub1" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.test-priv-sub1
  availability_zone = var.eu-west-2a-az

  tags = {
    Name = "test-private-sub1"
  }
}

#05.  2nd private subnet
resource "aws_subnet" "test-priv-sub2" {
  vpc_id     = aws_vpc.prod-rock-vpc.id
  cidr_block = var.test-priv-sub2
  availability_zone = var.eu-west-2b-az

  tags = {
    Name = "test-private-sub2"
  }
}


# PUBLIC ROUTE TABLE --------------
# 06. Public route table
resource "aws_route_table" "test-pub-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = "test-pub-route-table"
  }
}


# PRIVATE ROUTE TABLE --------------
# 07. Private route table
resource "aws_route_table" "test-priv-route-table" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  #associate nat gateway with private route table
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-nat-gateway.id
  }

  tags = {
    Name = "test-priv-route-table"
  }
}


# SUBNET ASSOCIATIONS PUBLIC----------------
# 08. 1st public subnet association
resource "aws_route_table_association" "test-public-sub1_rt_assoc" {
  subnet_id      = aws_subnet.test-public-sub1.id
  route_table_id = aws_route_table.test-pub-route-table.id
}

# 09. 2nd public subnet association
resource "aws_route_table_association" "test-public-sub2_rt_assoc" {
  subnet_id      = aws_subnet.test-public-sub2.id
  route_table_id = aws_route_table.test-pub-route-table.id
}

# SUBNET ASSOCIATIONS PRIVATE----------------
# 10. 1st private subnet association
resource "aws_route_table_association" "test-priv-sub1_rt_assoc" {
  subnet_id      = aws_subnet.test-priv-sub1.id
  route_table_id = aws_route_table.test-priv-route-table.id
}

# 11. 2nd private subnet association
resource "aws_route_table_association" "test-priv-sub2_rt_assoc" {
  subnet_id      = aws_subnet.test-priv-sub2.id
  route_table_id = aws_route_table.test-priv-route-table.id
}


# INTERNET GATEWAY --------------
# 12. internet gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id = aws_vpc.prod-rock-vpc.id

  tags = {
    Name = "test-igw"
  }
}

# 13. internet gatweay and public route table association
resource "aws_route" "test-igw_pub_rt_assoc" {
  route_table_id         = aws_route_table.test-pub-route-table.id
  gateway_id             = aws_internet_gateway.test-igw.id
  destination_cidr_block = "0.0.0.0/0"
}


# NAT GATEWAY -----------
# 14. nat gateway
resource "aws_nat_gateway" "test-nat-gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.test-public-sub1.id

  tags = {
    Name = "gw NAT"
  }

}

# 15. EIP 
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "Ansible Nat Gw EIP"
  }
}


# 16. security group
resource "aws_security_group" "test-sec-group" {
  name        = "ssh_and_http_sg"
  description = "allow ports 80 and 22"
  vpc_id      = aws_vpc.prod-rock-vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {
    Name = "allow_ssh_and_http"
  }
}


#17. 1st ec2 instance in public subnet
resource "aws_instance" "test-server1" {
  ami             = "ami-0758d98b134137d18"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.test-sec-group.id,aws_security_group.bastion-sec-group.id]
  subnet_id       = aws_subnet.test-public-sub1.id
  associate_public_ip_address = true
  availability_zone = var.eu-west-2a-az
  key_name        = "ubuntukey"

  tags = {
    Name = "Test Server 1"
  }

}


#18. 2nd ec2 instance in private subnet
resource "aws_instance" "test-server2" {
  ami             = "ami-0758d98b134137d18"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.test-sec-group.id]
  subnet_id       = aws_subnet.test-priv-sub1.id
  key_name        =  "ubuntukey"
  availability_zone = var.eu-west-2a-az

  tags = {
    Name = "Test Server 2"
  }

}

#18. Bastion host ec2 instance
resource "aws_instance" "bastion-host" {
  ami             = "ami-0758d98b134137d18"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.bastion-sec-group.id]
  subnet_id       = aws_subnet.test-public-sub1.id
  key_name        = "ubuntukey"
  associate_public_ip_address = true
  availability_zone = var.eu-west-2a-az

  tags = {
    Name = "Bastion Host"
  }

}


# 19. Bastion security group
resource "aws_security_group" "bastion-sec-group" {
  name        = "bastion-sec-group"
  description = "allow ports 80 and 22"
  vpc_id      = aws_vpc.prod-rock-vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = {
    Name = "allow_ssh_and_http"
  }
}

