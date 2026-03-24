resource "aws_eip" "eks_ngw_eip_1a" {
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-ngw-eip-1a"
    }
  )

}

resource "aws_eip" "eks_ngw_eip_1b" {
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-ngw-eip-1b"
    }
  )

}

resource "aws_nat_gateway" "eks_nat_gateway_1a" {
  allocation_id = aws_eip.eks_ngw_eip_1a.id
  subnet_id     = aws_subnet.eks_subnet_public_1a.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-ngw-1a"
    }
  )

}

resource "aws_nat_gateway" "eks_nat_gateway_1b" {
  allocation_id = aws_eip.eks_ngw_eip_1b.id
  subnet_id     = aws_subnet.eks_subnet_public_1b.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-ngw-1b"
    }
  )

}


resource "aws_route_table" "eks_private-1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway_1a.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-1a-route-table"
    }
  )
}

resource "aws_route_table" "eks_private-1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway_1b.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-1a-route-table"
    }
  )
}
