resource "aws_acm_certificate" "cert" {
  domain_name               = "shannonlucas.info"
  subject_alternative_names = ["www.shannonlucas.info"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.myzone.zone_id
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases = [
    "www.shannonlucas.info", "shannonlucas.info"
  ]
  comment             = "CF Distribution for shannonlucas.info "
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  retain_on_delete    = false
  wait_for_deployment = true


  default_cache_behavior {
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "shannonlucas.info"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_s3_bucket.shannon_public_domain_bucket.website_endpoint
    origin_id           = "shannonlucas.info"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
