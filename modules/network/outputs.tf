# Public outputs
output "public_subnet_id" {
  value = aws_subnet.public_subnet[0].id
}


# sg
output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

# vpc
output "aws_vpc" {
  value = aws_vpc.vpc.id
}