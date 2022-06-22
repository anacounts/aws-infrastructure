locals {
  main_domain_name = var.app_domain
  app_domain_name  = "app.${var.app_domain}"
  api_domain_name  = "api.${var.app_domain}"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = local.main_domain_name
  validation_method = "DNS"

  tags = {
    Name        = local.main_domain_name
    Environment = var.app_env
  }
}

resource "aws_route53_zone" "main" {
  name = local.main_domain_name

  tags = {
    Name        = local.main_domain_name
    Environment = var.app_env
  }
}

resource "aws_route53_record" "main" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.main.zone_id

  records = [each.value.record]

  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
}

resource "aws_route53_record" "main-app-alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.front.domain_name
    zone_id                = aws_cloudfront_distribution.front.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "main-api-alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api"
  type    = "A"
  ttl     = "60"

  records = [var.ec2_instance_ip]
}
