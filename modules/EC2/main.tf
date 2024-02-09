resource "aws_instance" "ec2-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_output
  key_name      = "tf-key-pair"
  tags = {
    Name = "public-ec2"
  }
  vpc_security_group_ids      = [var.ec2_security_group_id]
  associate_public_ip_address = true
}



resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair"
}
