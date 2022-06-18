module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "bootcamp-myawsbucket-tf-remote-state"
  acl    = "private"

  block_public_acls = true

  # Allow deletion of non-empty bucket
  force_destroy = true

  versioning = {
    enabled = false
  }

}