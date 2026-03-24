resource "aws_subnet" "eks_subnet_public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone       = "${data.aws_region.current.region}a"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name                     = "${var.prefix}-public-subnet-1a"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

resource "aws_subnet" "eks_subnet_public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  availability_zone       = "${data.aws_region.current.region}b"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name                     = "${var.prefix}-public-subnet-1b"
      "kubernetes.io/role/elb" = "1"
    }
  )
}

resource "aws_route_table_association" "eks_public_1a_association" {
  subnet_id      = aws_subnet.eks_subnet_public_1a.id
  route_table_id = aws_route_table.eks_public.id

}

resource "aws_route_table_association" "eks_public_1b_association" {
  subnet_id      = aws_subnet.eks_subnet_public_1b.id
  route_table_id = aws_route_table.eks_public.id

}
