resource "aws_route53_zone" "myzone" {
  name = "shannonlucas.info"
}

resource "aws_route53_record" "a" {
  zone_id = aws_route53_zone.myzone.zone_id
  name    = "shannonlucas.info"
  type    = "A"

  alias {
    evaluate_target_health = false
    # you can use these instead of the cloudfront links if you are not utilizing https
    # name                   = aws_s3_bucket.shannon_public_domain_bucket.website_domain
    # zone_id = aws_s3_bucket.shannon_public_domain_bucket.hosted_zone_id
    name    = aws_cloudfront_distribution.distribution.domain_name
    zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "a_subdomain" {
  zone_id = aws_route53_zone.myzone.zone_id
  name    = "www.shannonlucas.info"
  type    = "A"

  alias {
    evaluate_target_health = false
    # you can use these instead of the cloudfront links if you are not utilizing https
    # name                   = aws_s3_bucket.shannon_public_subdomain_bucket.website_domain
    # zone_id = aws_s3_bucket.shannon_public_subdomain_bucket.hosted_zone_id
    name    = aws_cloudfront_distribution.distribution.domain_name
    zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
  }
}