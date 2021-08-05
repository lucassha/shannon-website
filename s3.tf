# bucket and bucket object for domain "shannonlucas.info"
resource "aws_s3_bucket" "shannon_public_domain_bucket" {
  bucket = "shannonlucas.info"
  acl    = "public-read"
  policy = file("domain_policy.json")

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "domain_index" {
  bucket       = aws_s3_bucket.shannon_public_domain_bucket.bucket
  key          = "index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
  source       = "${path.module}/index.html"
}

# bucket and bucket object for subdomain "www.shannonlucas.info"
resource "aws_s3_bucket" "shannon_public_subdomain_bucket" {
  bucket = "www.shannonlucas.info"
  acl    = "public-read"
  policy = file("subdomain_policy.json")

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "subdomain_index" {
  bucket       = aws_s3_bucket.shannon_public_subdomain_bucket.bucket
  key          = "index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
  source       = "${path.module}/index.html"
}