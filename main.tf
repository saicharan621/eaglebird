provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "eagle_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "eagle-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "eagle_gw" {
  vpc_id = aws_vpc.eagle_vpc.id
  tags   = { Name = "eagle-gw" }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.eagle_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags                    = { Name = "public-subnet" }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eagle_vpc.id
  tags   = { Name = "public-route-table" }
}

# Route for Internet Access
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eagle_gw.id
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "eagle_sg" {
  vpc_id = aws_vpc.eagle_vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "eagle-sg" }
}

# Instances
resource "aws_instance" "jenkins" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t3.medium"
  key_name               = "javaapp"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.eagle_sg.id]
  tags                   = { Name = "eagle-jenkins" }
}

resource "aws_instance" "nexus" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t3.medium"
  key_name               = "javaapp"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.eagle_sg.id]
  tags                   = { Name = "eagle-nexus" }
}

resource "aws_instance" "sonarqube" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t3.medium"
  key_name               = "javaapp"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.eagle_sg.id]
  tags                   = { Name = "eagle-sonarqube" }
}

resource "aws_instance" "eks_master" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t3.medium"
  key_name               = "javaapp"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.eagle_sg.id]
  tags                   = { Name = "eagle-eks-master" }
}

resource "aws_instance" "eks_worker" {
  ami                    = "ami-023a307f3d27ea427"
  instance_type          = "t3.medium"
  key_name               = "javaapp"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.eagle_sg.id]
  tags                   = { Name = "eagle-eks-worker" }
}

# Outputs
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "nexus_public_ip" {
  value = aws_instance.nexus.public_ip
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube.public_ip
}

output "eks_master_public_ip" {
  value = aws_instance.eks_master.public_ip
}

output "eks_worker_public_ip" {
  value = aws_instance.eks_worker.public_ip
}
