# Create VPC
provider "aws" {
  region = var.region
}
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = "${var.vpc-cidr}"
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.Project_Name}-A"
  }
}

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {  
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.Project_Name}-IGW"
  }
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.Project_Name}-Public Subnet 1"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.Project_Name}-Public Subnet 2"
  }
}

# Create Public Subnet 3
# terraform aws create subnet
resource "aws_subnet" "public-subnet-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-3-cidr}"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "${var.Project_Name}-Public Subnet 3"
  }
}


# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "${var.Project_Name}-Public Route Table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 3 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-3-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-3.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.Project_Name}-Private Subnet 1"
  }
}

# Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.Project_Name}-Private Subnet 2"
  }
}

# Create Private Subnet 3
# terraform aws create subnet
resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "${var.Project_Name}-Private Subnet 3"
  }
}

 #Route table for Private Subnet's
resource "aws_route_table" "PrivateRT" {    
  vpc_id = aws_vpc.vpc.id
  route {
  cidr_block = "0.0.0.0/0"            
  nat_gateway_id = aws_nat_gateway.NATgw.id
  }
  tags      = {
    Name    = "${var.Project_Name}-Private rt "
  }
}

#Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation-1" {
  subnet_id = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.PrivateRT.id
}

#Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation-2" {
  subnet_id = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.PrivateRT.id
}

#Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation-3" {
  subnet_id = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.PrivateRT.id
} 

resource "aws_eip" "nateIP" {
   vpc   = true
}
 #Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id = aws_subnet.public-subnet-1.id

  tags      = {
    Name    = "${var.Project_Name}-NAT"
  }
}

