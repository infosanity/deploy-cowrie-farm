resource "aws_s3_bucket" "output" {
  bucket = "cowrie-output-${random_string.random.result}"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.output.id
  acl    = "private"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

output "output_bucket" {
  value = aws_s3_bucket.output.bucket
}