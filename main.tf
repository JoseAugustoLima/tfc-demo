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
  instance_type = "t2.nano"
  
  tags = {
    Name = "DemoServer-TFC"
  }
  
}
