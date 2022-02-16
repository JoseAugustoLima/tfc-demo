terraform {

  required_version = ">= 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  cloud {
    organization = "hashicorp-se"
    workspaces {
      name = "tfc-demo"
    }
  }

}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "demo_server" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.small"
  tags = {
    Name = var.instance_name
  }
}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

resource "random_pet" "random" {
  
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "my-demo-s3-${random_pet.random.id}"
  acl           = "private"
  force_destroy = true

  versioning = {
    enabled = false
  }

  tags = {
     Owner   = "SE"
     Purpose = "Demo"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
