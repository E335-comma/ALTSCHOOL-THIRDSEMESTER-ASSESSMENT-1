resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "cloudlaunch_environment"
    Terraform   = "true"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name      = "cloudlaunch-public-subent"
    Terraform = "true"
  }
}

resource "aws_subnet" "application_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.application_subnet_cidr

  tags = {
    Name      = "cloudlaunch-application-subnet"
    Terraform = "true"
  }
}

resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.database_subnet_cidr

  tags = {
    Name      = "cloudlaunch-database-subnet"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "cloudlaunch-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name      = "cloudlaunch-public-rt"
    Terraform = "true"
  }
}

resource "aws_route_table" "application_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "cloudlaunch-app-rt"
    Terraform = "true"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "cloudlaunch-db-rt"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnet]
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_route_table_association" "application" {
  depends_on     = [aws_subnet.application_subnet]
  route_table_id = aws_route_table.application_route_table.id
  subnet_id      = aws_subnet.application_subnet.id
}

resource "aws_route_table_association" "database" {
  depends_on     = [aws_subnet.database_subnet]
  route_table_id = aws_route_table.database_route_table.id
  subnet_id      = aws_subnet.database_subnet.id
}

resource "aws_security_group" "application_security_group" {
    name = "cloudlaunch-app-sg"
    description = "enable http access on port 10"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "http access"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "cloudlaunch-app-sg"
    }
}

resource "aws_security_group" "database_security_group" {
    name = "cloudlaunch-db-sg"
    description = "enable MySGL access on port 3306"
    vpc_id = aws_vpc.vpc.id

    ingress {
        description = "MySQL from allowed subnet"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = [var.application_subnet_cidr]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks =  ["0.0.0.0/0"]
    }

    tags = {
        Name = "cloudlaunch-db-sg"
    }
}
