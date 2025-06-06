resource "aws_vpc_peering_connection" "roboshop" {
  vpc_id      = aws_vpc.roboshop.id
  peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id
  auto_accept = var.acceptor_vpc_id == "" ? true : false
  tags = {
    Name = local.name
  }
}

resource "aws_route" "default" {
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop.id
}

resource "aws_route" "public_peering" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop.id
}

resource "aws_route" "private_peering" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop.id
}

resource "aws_route" "database_peering" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.roboshop.id
}
