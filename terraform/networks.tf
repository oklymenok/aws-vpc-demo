# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev-vpc.id
}

# Create route table
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dev-rt"
  }
}

# Create a Subnet
resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.0.0/28"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-a"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.0.16/28"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.0.32/28"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-b"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.0.48/28"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-b"
  }
}

# Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.dev-route-table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.dev-route-table.id
}