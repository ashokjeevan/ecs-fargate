locals {
    state_bucket_name = "ecs-fargate-state-bucket"
}

resource "aws_s3_bucket" "state_bucket" {
    bucket = local.state_bucket_name
    object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
    bucket = aws_s3_bucket.state_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
    bucket = aws_s3_bucket.state_bucket.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_s3_bucket_public_access_block" "state_bucket_public_access" {
    bucket = aws_s3_bucket.state_bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "state_table" {
    name = "ecs-fargate-state-table"
    
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}