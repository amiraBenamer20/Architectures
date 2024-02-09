resource "aws_route53_zone" "my_route53_zone" {
  name = "restaurant.com"  # Replace with your domain name
}

resource "aws_route53_record" "cloudfront_record" {
  zone_id = aws_route53_zone.my_route53_zone.zone_id
  name    = "mysite.restaurant.com"  # Replace with your desired subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
