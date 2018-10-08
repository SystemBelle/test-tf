# test-tf/stacks/tf-env-init/main.tf

resource "aws_kms_key" "state_key" {
  description             = "KMS key for Terraform state S3 bucket"
  deletion_window_in_days = 10
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#  S3 bucket to store access logs for Terraform state
resource "aws_s3_bucket" "tf_state_bucket_access_logs" {
  bucket = "${var.tf_state_access_logs_bucket}"
  region = "${var.aws_region}"
  acl    = "log-delivery-write"
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.tf_state_bucket}"
  region = "${var.aws_region}"
  acl    = "private"

  versioning {
    enabled = "true"
  }

  # Prevent accidental destruction
  lifecycle {
    prevent_destroy = "true"
  }

  # Log bucket access to a separate bucket
  logging {
    target_bucket = "${aws_s3_bucket.tf_state_bucket_access_logs.id}"
    # target_prefix = "logs/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.state_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    Name = "terraform-state"
  }
}

#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

resource "aws_dynamodb_table" "terraform-state-lock" {
  name           = "dev"
  read_capacity  = "20"
  write_capacity = "20"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "Terraform state lock"
  }
}
