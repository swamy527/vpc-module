resource "aws_vpc" "myvpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = "true"
  tags = {
    Name = local.Name
  }
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = local.Name
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = local.available_zones[count.index]
  tags = {
    Name = "${local.Name}-public"
  }

}

resource "aws_subnet" "private" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = local.available_zones[count.index]
  tags = {
    Name = "${local.Name}-private"
  }
}

resource "aws_subnet" "database" {
  count             = length(var.database_cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.database_cidr[count.index]
  availability_zone = local.available_zones[count.index]
  tags = {
    Name = "${local.Name}-databse"
  }
}

resource "aws_eip" "myip" {
}

resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.myip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.environment}-${var.project}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.mygw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw.id
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynat.id
  }

}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynat.id
  }

}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private[*].id)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count          = length(aws_subnet.database[*].id)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
