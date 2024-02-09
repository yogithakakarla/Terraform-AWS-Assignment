output "vpc-id" {
  value = aws_vpc.Main.id
}
output "public_subnet_output" {
  value = aws_subnet.public_subnets.*.id
}
output "private_subnet_output" {
  value = aws_subnet.private_subnets.*.id
}
output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
