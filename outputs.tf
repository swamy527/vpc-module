output "available_zones" {
  value = data.aws_availability_zones.zones.names
}

output "vpcid" {
  value = aws_vpc.myvpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}
