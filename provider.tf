terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket         = "ecs-fargate-state-bucket"
        key            = "dev/ecs-fargate/terraform.tfstate"
        region         = "ca-central-1"
        dynamodb_table = "ecs-fargate-state-table"
        profile        = "original"
    }
}

provider "aws" {
    region = "ca-central-1"
    profile = "original"
}