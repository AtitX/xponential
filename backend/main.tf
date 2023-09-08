terraform {
  required_version = ">= 1.0.0"
    # backend "s3" {
    # }
}

provider "aws" {
  region = var.region
}

resource "random_id" "id" {
  byte_length = 8
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${random_id.id.hex}"
  force_destroy = true
  # versioning {
  #   enabled = true
  # }

  # Enable server-side encryption by default
  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "AES256"
  #     }
  #   }
  # }
}

resource "aws_kms_key" "s3key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}