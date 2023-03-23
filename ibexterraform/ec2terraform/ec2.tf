# Create EC2
provider "aws" {
  region = var.region
}
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = [var.vpcname]
  }
}

data "aws_subnet" "selected" {
  filter {
    name = "tag:Name"
    values = [var.subnetname]
  }
}

data "aws_key_pair" "keypair" {
  key_name           = var.keypairname
  include_public_key = true
}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_security_group" "web-sg" {
  name = var.sg
  vpc_id = data.aws_vpc.selected.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  
  tags = {
		Name = "EC2pubsg"	
	
	}
}


resource "aws_instance" "webserver" {

  ami = data.aws_ami.amazon-2.id
  instance_type               = var.instance_type
  key_name                    = data.aws_key_pair.keypair.key_name
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  associate_public_ip_address = true
  user_data                   = "${file("userdata.sh")}"
	tags = {
		Name = "EC2public"	
	
	}
}

  

 




