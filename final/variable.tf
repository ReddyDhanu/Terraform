variable "region" {
  default     = "us-east-2"
  description = "AWS Region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR"
}

variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 CIDR"
}

variable "public_subnet_3_cidr" {
  description = "Public Subnet 3 CIDR"
}

variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
}

variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
}

variable "private_subnet_3_cidr" {
  description = "Private Subnet 3 CIDR"
}
variable "amiid" {
  type = "map"
  default = {
    us-east-2 = "ami-0d5d9d301c853a04a"
    us-east-1 = "ami-04b9e92b5572fa0d1"
    eu-west-2 = "ami-06d51e91cea0dac8d"
  }
  description = "You may added more regions if you want"
}

variable "instance_count" {
  default = "1"
}
variable "key_name" {
  default = "Dhanu"
  
}

#variable "security_group" {
#}
