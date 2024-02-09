output "public-ip" {
  value = "Public ip of an instance : ${aws_instance.ec2-instance.public_ip}"
}
output "subnet_id" {
  value = aws_instance.ec2-instance.subnet_id
}
