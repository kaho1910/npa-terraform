## Create Bucket

# configure bucket name
# make it private

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, { Name = "${var.addName}-bucket"})
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  acl = "private"
}
