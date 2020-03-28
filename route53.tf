#route53.tf

resource "aws_route53_zone" "terraform_s3_route53_zone" {
  name = "${var.site_domain}"

  tags = {
    Name = "${var.site_domain}"
  }
}

resource "aws_route53_record" "site" {
  zone_id = "${aws_route53_zone.terraform_s3_route53_zone.zone_id}"
  name = "${var.site_domain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.site.domain_name}"
    zone_id = "${aws_cloudfront_distribution.site.hosted_zone_id}"
    evaluate_target_health = false
  }
}



