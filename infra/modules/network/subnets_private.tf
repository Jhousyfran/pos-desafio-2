resource "aws_subnet" "eks_subnet_private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 3)
  availability_zone = "${data.aws_region.current.region}a"

  tags = merge(
    var.tags,
    {
      Name                              = "${var.prefix}-private-subnet-1a"
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

resource "aws_subnet" "eks_subnet_private_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 4)
  availability_zone = "${data.aws_region.current.region}b"

  tags = merge(
    var.tags,
    {
      Name                              = "${var.prefix}-private-subnet-1b"
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

resource "aws_route_table_association" "eks_private_1a_association" {
  subnet_id      = aws_subnet.eks_subnet_private_1a.id
  route_table_id = aws_route_table.eks_private-1a.id

}

resource "aws_route_table_association" "eks_private_1b_association" {
  subnet_id      = aws_subnet.eks_subnet_private_1b.id
  route_table_id = aws_route_table.eks_private-1b.id

}
