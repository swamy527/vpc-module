output "all_zones" {
  value = data.aws_availability_zones.azs.names
}

output "vpc_id" {
  value = aws_vpc.roboshop.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "database_subnets" {
  value = aws_subnet.database[*].id
}
