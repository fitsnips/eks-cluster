
##### PROVIDER #######
provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags_default
  }

}

### KMS
resource "aws_kms_key" "terraform_remote_state" {
  description             = "Encryption at rest key for state files"
  enable_key_rotation     = true
  deletion_window_in_days = 30 # once a month seems reasonable
}

# help humans identify the keyS
resource "aws_kms_alias" "terraform_remote_state" {
  name          = "alias/${terraform.workspace}-state-key"
  target_key_id = aws_kms_key.terraform_remote_state.key_id
}


### S3 Bucket to store s3 state
resource "aws_s3_bucket" "remote_state_logging" {
  bucket = "${var.tfstate_name}-logging"
  force_destroy = true
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_ownership_controls" "remote_state_logging" {
  bucket = aws_s3_bucket.remote_state_logging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "remote_state_logging" {
  bucket = aws_s3_bucket.remote_state_logging.id

  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "READ"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }

}

# versioning of tfstate files is life saving!
resource "aws_s3_bucket_versioning" "remote_state_logging" {
  bucket = aws_s3_bucket.remote_state_logging.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_logging" {
  bucket = aws_s3_bucket.remote_state_logging.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_remote_state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "remote_state_logging" {
  bucket = aws_s3_bucket.remote_state_logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# this bucket will contain sensative data, and should be secured
# from almost everyone, ideally only tooling has access but that 
# is not realistic, and at the very least a break glass solution 
# would be needed.
resource "aws_s3_bucket" "remote_state" {
  bucket = var.tfstate_name
  force_destroy = true  
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_s3_bucket_logging" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id

  target_bucket = aws_s3_bucket.remote_state_logging.id
  target_prefix = var.tfstate_name
}

resource "aws_s3_bucket_acl" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  acl    = "private"
}

# versioning of tfstate files is life saving!
resource "aws_s3_bucket_versioning" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state" {
  bucket = aws_s3_bucket.remote_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_remote_state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

### Dynamo
# provision terraform lock table, not requested but very 
# important to multi user enviorments
resource "aws_dynamodb_table" "locks" {
  name         = var.tfstate_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
