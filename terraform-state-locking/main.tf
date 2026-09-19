#vpc creation  
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags={
    Name="main-vpc"
  }
}

#internet gateway creation and attach to vpc
resource "aws_internet_gateway" "igw"{
    vpc_id =aws_vpc.main.id

    tags={
        Name="igw"
    }
}

#public subnet creation 
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_instance" "web" {
  ami           = "ami-0fef201115eefe936" # Amazon Linux 2 AMI
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "web-instance"
  }
}


resource "null_resource" "lock_test" {
  provisioner "local-exec" {
    command = "timeout /t 30"
  }
}