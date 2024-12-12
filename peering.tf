resource "aws_vpc_peering_connection" "mypeer" {
  count       = var.peering_required ? 1 : 0
  vpc_id      = aws_vpc.myvpc.id
  peer_vpc_id = var.vpc_acceptor_id == "" ? data.aws_vpc.default.id : var.vpc_acceptor_id
  auto_accept = var.vpc_acceptor_id == "" ? true : false
}

resource "aws_route" "acceptor_route" {
  count                     = var.peering_required && var.vpc_acceptor_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mypeer[0].id
}

resource "aws_route" "public_route" {
  count                     = var.peering_required && var.vpc_acceptor_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mypeer[0].id
}

resource "aws_route" "private_route" {
  count                     = var.peering_required && var.vpc_acceptor_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mypeer[0].id
}

resource "aws_route" "database_route" {
  count                     = var.peering_required && var.vpc_acceptor_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mypeer[0].id
}
