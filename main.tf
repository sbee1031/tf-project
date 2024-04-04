terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
  }

  backend "s3" {
    bucket = "tf-backend-lsb"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# module "default_custom_vpc" {
#   source = "./custom_vpc"
#   env    = "dev"
# }

# module "prd_custom_vpc" {
#   source = "./custom_vpc"
#   env    = "prd"
# }

variable "envs" {
  type    = list(string)
  default = ["dev", "prd", ""]
}

# variable "names" {
#   type    = list(string)
#   default = ["seulbee", "sam"]
# }

# # count 사용하기
# module "personal_custom_vpc" {
#   count  = 2
#   source = "./custom_vpc"
#   env    = "personal_${count.index}"
# }

# # for_each 사용하기
# module "personal_custom_vpc" {
#   # for_each = toset(var.names)
#   # for_each = toset([for name in var.names : "${name}_human"])
#   source = "./custom_vpc"
#   env    = "personal_${each.key}"
# }

# 조건문 사용하기
module "vpc_list" {
  for_each = toset([for env in var.envs : env if env != ""])
  source   = "./custom_vpc"
  env      = each.key
}

# 버켓명은 모든 계정에서 고유해야 함
resource "aws_s3_bucket" "tf_backend_lsb" {
  bucket = "tf-backend-lsb"

  tags = {
    Name = "tf-backend-lsb"
  }
}

resource "aws_s3_bucket_versioning" "tf_backend_lsb_versioning" {
  bucket = aws_s3_bucket.tf_backend_lsb.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "tf_backend_lsb_acl" {
  bucket = aws_s3_bucket.tf_backend_lsb.id
  acl    = "private"
}

# # 	3.37.95.244
# resource "aws_eip" "eip_temp" {
#   tags = {
#     Name = "temp"
#   }
# }

# # provisioner 사용해보기
# resource "aws_eip" "eip_temp" {
#   provisioner "local-exec" {
#     command = "echo ${self.public_ip}"
#   }

#   tags = {
#     Name = "temp"
#   }

# }
