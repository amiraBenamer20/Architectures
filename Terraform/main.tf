


#----------------------------Data
#AMI
data "aws_ssm_parameter" "amazon2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#----------------------------Resources 
#*****Networking
#vpc
resource "aws_vpc" "mqueen_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
   
  tags = local.common_tags

}

#internet_gw
resource "aws_internet_gateway" "mqueen_gw" {
  vpc_id = aws_vpc.mqueen_vpc.id

  tags = local.common_tags
}

#subnet
resource "aws_subnet" "mqueen_public_subnet1" {
  vpc_id = aws_vpc.mqueen_vpc.id
  cidr_block = var.subnet1_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = local.common_tags
}

#routing table & association
resource "aws_route_table" "mqueen_route_table" {
  vpc_id = aws_vpc.mqueen_vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mqueen_gw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "mqueen_subnet1" {
  route_table_id = aws_route_table.mqueen_route_table.id
  subnet_id = aws_subnet.mqueen_public_subnet1.id
}


#*****Security
#security_group
resource "aws_security_group" "mqueen_front_end_sg" {
  name = "mqueen_front_end_sg"
  vpc_id = aws_vpc.mqueen_vpc.id

  #HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}


#****Computing
#ec2_instance
resource "aws_instance" "front_end_server" {
  ami = nonsensitive(data.aws_ssm_parameter.amazon2_linux.value)
  instance_type = var.instance_type
  subnet_id = aws_subnet.mqueen_public_subnet1.id
  vpc_security_group_ids = [aws_security_group.mqueen_front_end_sg.id]
  user_data = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install -y nginx1
    sudo service nginx start
    sudo rm /usr/share/nginx/html/index.html
    echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
  EOF

  tags = local.common_tags
}