resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "fastcampus_default_vpc_${var.env}"
  }
}

resource "aws_subnet" "public_subnet_1" {
  count             = var.env == "prd" ? 0 : 1
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "fastcampus_public_subnet_1_${var.env}"
  }
}

# # 에러 발생 - subnet count 때문에 연결한 subnet_id 가 없으므로
# resource "aws_nat_gateway" "public_nat" {
#   connectivity_type = "public"
#   subnet_id         = aws_subnet.public_subnet_1[0].id
# }

resource "aws_nat_gateway" "public_nat" {
  count             = var.env == "prd" ? 0 : 1
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnet_1[0].id

}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = local.az_a

  tags = {
    Name = "fastcampus_private_subnet_1_${var.env}"
  }
}

# # 이미 콘솔에서 생성한 리소스는 data id 를 통해 가져옴
# data "aws_subnet" "private_subnet_2" {
#   id = "subnet-0d8c8bb2c8e9e8718"
# }

# # 비용 부과로 주석처리
# resource "aws_nat_gateway" "private_nat" {
#   connectivity_type = "private"
#   subnet_id         = aws_subnet.private_subnet_1.id

#   tags = {
#     Name = "fastcampus_private_nat_${var.env}"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.default.id

#   tags = {
#     Name = "fastcampus_igw_${var.env}"
#   }



