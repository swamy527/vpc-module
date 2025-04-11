output "all_zones" {
  value = data.aws_availability_zones.azs.names
}

output "vpc_id" {
  value = aws_vpc.roboshop.id
}
