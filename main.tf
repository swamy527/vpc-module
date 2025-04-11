resource "aws_vpc" "roboshop" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.dns_host
  tags = merge(var.common_tags, var.vpc_tags, {
    Name = local.name
    }
  )
}

resource "aws_internet_gateway" "roboshop" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(var.common_tags, var.gateway, {
    Name = local.name
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.roboshop.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }

}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.roboshop.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  tags = {
    Name = "private"
  }

}

resource "aws_subnet" "database" {
  count             = length(var.database_subnet)
  vpc_id            = aws_vpc.roboshop.id
  cidr_block        = var.database_subnet[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  tags = {
    Name = "database"
  }
}

resource "aws_eip" "roboshop" {

}

resource "aws_nat_gateway" "roboshop" {
  allocation_id = aws_eip.roboshop.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.roboshop]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.roboshop.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.roboshop.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.roboshop.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop.id
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.roboshop.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
