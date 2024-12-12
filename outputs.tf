output "available_zones" {
  value = data.aws_availability_zones.zones.names
}

output "vpcid" {
  value = aws_vpc.myvpc.id
}

