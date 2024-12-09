# Provider , VPC , 2 Public Subnets (for the ALB) , 2 Private Subnets (for the RDS) , Internet Gateway for the Public Subnet


#Provider 

terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
    region     = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

#VPC

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"

    tags   = {
      name = "prod-vpc"
    }
  
}

#Public Subnet 1

resource "aws_subnet" "my_public_subnet_1" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a" 
    map_public_ip_on_launch = true

    tags   = {
      name = "prod-Public"
    }
  
}

#Public Subnet 2 (χρειάζονται 2 τουλάχιστον public subnets σε διαφορετικά AZs για να λειτουργήσει ο ALB(ανθεκτικότητα))

resource "aws_subnet" "my_public_subnet_2" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b" 
    map_public_ip_on_launch = true

    tags   = {
      name = "prod-Public"
    }
  
}

#Private Subnet

resource "aws_subnet" "my_private_subnet_1" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.4.0/24"
    availability_zone = "us-east-1a"

    tags   = {
      name = "prod-Private-1"
    }
  
}


#Private Subnet 2(χρειάζονται 2 τουλάχιστον private subnets σε διαφορετικά AZs για να λειτουργήσει η RDS(ανθεκτικότητα))

resource "aws_subnet" "my_private_subnet_2" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.3.0/24"
    availability_zone = "us-east-1b"

    tags   = {
      name = "prod-Private-2"
    }
  
}

#Internet Gateway for the public subnet

resource "aws_internet_gateway" "my_int_gateway" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      name = "Internet Gateway for the public Subnet"
    }
  
}

# Route Table for Public Subnet 1
resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.my_vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_int_gateway.id
  }

  tags = {
    Name = "Public Route Table 1"
  }
}

# Route Table for Public Subnet 2
resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.my_vpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_int_gateway.id
  }

  tags = {
    Name = "Public Route Table 2"
  }
}


# Associate Route Table with Public Subnet 1
resource "aws_route_table_association" "rt_assoc_public_1" {
  subnet_id      = aws_subnet.my_public_subnet_1.id
  route_table_id = aws_route_table.public_rt_1.id

}

# Associate Route Table with Public Subnet 2
resource "aws_route_table_association" "rt_assoc_public_2" {
  subnet_id      = aws_subnet.my_public_subnet_2.id
  route_table_id = aws_route_table.public_rt_2.id
}


