variable "ami" {
  type    = string
  default = "ami-087c4d241dd19276d"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}


variable "public_subnet_output" {
}

variable "ec2_security_group_id" {
}

