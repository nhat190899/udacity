data "aws_availability_zones" "available" {
  state = "available"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "./lambda.py"

  tags = {
    Name = "my-lambda1"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "udacity_vpc"
  }
}

resource "aws_security_group" "UDARR-Application" {
  name        = "UDARR-Application"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.129.65/32"]
  }

  tags = {
    Name = "udacity"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = var.subnet3_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "udacity_public_subnet_1"
  }
}

resource "aws_instance" "web1" {
  ami                    = "ami-06b09bfacae1453cb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.UDARR-Application.id]
  subnet_id              = aws_subnet.public_subnet_1.id
}
resource "aws_instance" "web2" {
  ami                    = "ami-06b09bfacae1453cb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.UDARR-Application.id]
  subnet_id              = aws_subnet.public_subnet_1.id
}
resource "aws_instance" "web3" {
  ami                    = "ami-06b09bfacae1453cb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.UDARR-Application.id]
  subnet_id              = aws_subnet.public_subnet_1.id
}
resource "aws_instance" "web4" {
  ami                    = "ami-06b09bfacae1453cb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.UDARR-Application.id]
  subnet_id              = aws_subnet.public_subnet_1.id
}
