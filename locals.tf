locals {
  tag = {
    Name = "${var.environment}-${var.project}"
  }
  available_zones = slice(data.aws_availability_zones.zones.names, 0, 2)
}
