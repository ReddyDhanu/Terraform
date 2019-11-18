provider "aws" {
  region = "${var.region}"
}


terraform {
  backend "s3" {
    bucket = "dhanureddy"
    key    = "tfstatefiles/terraform.tfstate"
    region = "us-east-2"
  }
}


resource "aws_vpc" "dhanu-vpc" {
  cidr_block            = "${var.vpc_cidr}"
  enable_dns_hostnames  = true

  tags ={
    Name = "dhanu-VPC"
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = "${var.public_subnet_1_cidr}"
  vpc_id            = "${aws_vpc.dhanu-vpc.id}"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  cidr_block        = "${var.public_subnet_2_cidr}"
  vpc_id            = "${aws_vpc.dhanu-vpc.id}"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Public-Subnet-2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  cidr_block        = "${var.public_subnet_3_cidr}"
  vpc_id            = "${aws_vpc.dhanu-vpc.id}"
  availability_zone = "us-east-2c"

  tags = {
    Name = "Public-Subnet-3"
  }
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block        = "${var.private_subnet_1_cidr}"
  vpc_id            = "${aws_vpc.dhanu-vpc.id}"
  availability_zone = "us-east-2a"

  tags  = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block        = "${var.private_subnet_2_cidr}"
  vpc_id            = "${aws_vpc.dhanu-vpc.id}"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  cidr_block        = "${var.private_subnet_3_cidr}"
  vpc_id            = "${aws_vpc.dhanu-vpc.id}"
  availability_zone = "us-east-2c"

  tags = {
    Name = "Private-Subnet-3"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.dhanu-vpc.id}"

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = "${aws_vpc.dhanu-vpc.id}"

  tags =  {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "public-subnet-1-association" {
  route_table_id  = "${aws_route_table.public-route-table.id}"
  subnet_id       = "${aws_subnet.public-subnet-1.id}"
}

resource "aws_route_table_association" "public-subnet-2-association" {
  route_table_id  = "${aws_route_table.public-route-table.id}"
  subnet_id       = "${aws_subnet.public-subnet-2.id}"
}

resource "aws_route_table_association" "public-subnet-3-association" {
  route_table_id  = "${aws_route_table.public-route-table.id}"
  subnet_id       = "${aws_subnet.public-subnet-3.id}"
}

resource "aws_route_table_association" "private-subnet-1-association" {
  route_table_id  = "${aws_route_table.private-route-table.id}"
  subnet_id       = "${aws_subnet.private-subnet-1.id}"
}

resource "aws_route_table_association" "private-subnet-2-association" {
  route_table_id  = "${aws_route_table.private-route-table.id}"
  subnet_id       = "${aws_subnet.private-subnet-2.id}"
}

resource "aws_route_table_association" "private-subnet-3-association" {
  route_table_id  = "${aws_route_table.private-route-table.id}"
  subnet_id       = "${aws_subnet.private-subnet-3.id}"
}

resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "dhanu-EIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.elastic-ip-for-nat-gw.id}"
  subnet_id     = "${aws_subnet.public-subnet-1.id}"

  tags = {
    Name = "dhanu-NAT-GW"
  }

  depends_on = ["aws_eip.elastic-ip-for-nat-gw"]
}

resource "aws_route" "nat-gw-route" {
  route_table_id          = "${aws_route_table.private-route-table.id}"
  nat_gateway_id          = "${aws_nat_gateway.nat-gw.id}"
  destination_cidr_block  = "0.0.0.0/0"
}

resource "aws_internet_gateway" "dhanu-igw" {
  vpc_id = "${aws_vpc.dhanu-vpc.id}"

  tags = {
    Name = "dhanu-IGW"
  }
}

resource "aws_route" "public-internet-gw-route" {
  route_table_id          = "${aws_route_table.public-route-table.id}"
  gateway_id              = "${aws_internet_gateway.dhanu-igw.id}"
  destination_cidr_block  = "0.0.0.0/0"
}


#resource "aws_security_group" "dhanu_sg" {
#  name = "security group"
#  description = "Security group"
#  vpc_id = "${aws_vpc.dhanu-vpc.id}"
#
#  ingress {
#    from_port = 22
#    to_port = 22
#    protocol = "tcp"
#  }
resource "aws_security_group"  "dhanu_sg" {
  name   = "security group_dhanu"
  description = "allow ports"
  vpc_id  = "${aws_vpc.dhanu-vpc.id}"
  
  ingress {
   from_port  = 22
   to_port    = 22
   protocol   = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
   from_port  = 80
   to_port    = 80
   protocol   = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
   from_port  = 0
   to_port    = 0
   protocol   = "-1"
   cidr_blocks = ["0.0.0.0/0"]
   }
  
  tags = {
    Name = "DhanuSG"

  }
}

resource "aws_eip_association" "eip-assoc" {
#  vpc   = true
#  instance_id   = "${aws_instance.Dhanuinstance.*.id[0]}"
 # allocation_id = "${aws_eip_association.eip-assoc.id}"
}

resource "aws_instance" "Dhanuinstance" {
   
  ami = "${lookup(var.amiid, var.region)}"
  instance_type = "t2.micro"
  count = "${var.instance_count}"
#  vpc_id = "${aws_vpc.dhanu-vpc.id}"
  subnet_id     = "${aws_subnet.public-subnet-1.id}"
  vpc_security_group_ids = ["${aws_security_group.dhanu_sg.id}"]
#  allocation_id = "${aws_eip_association.eip-assoc.id}"
  #depends_on = ["aws_eip_association.eip-assoc"]
  depends_on = ["aws_security_group.dhanu_sg"]
#   vpc_security_group_ids = ["${var.security_group}"]
  
   
  key_name = "${var.key_name}"

  tags = {
      Name = "terraformInst--${count.index + 1}"
   }
  provisioner "file" {
    source      = "/home/ubuntu/.ssh/id_rsa.pub"
    destination = "/tmp/id_rsa.pub"
  }

  user_data = "${file("user-data.txt")}"

connection {
    host = "${self.private_ip}"
    type     = "ssh"
    user     = "ubuntu"
#    password = ""
    private_key = "${file("~/Dhanu.pem")}"
  }

}
#resource "aws_instance" "eip-assoc" {
##  vpc   = true
#  instance_id   = "${aws_instance.Dhanuinstance.*.id[0]}"
#  allocation_id = "${aws_eip_association.eip-assoc.id}"
#}
output "public_ip" {

  value = "${formatlist("%v", aws_instance.Dhanuinstance.*.public_ip)}"
}


