#acm.tf

resource "aws_acm_certificate" "acm_cert" {
  provider = "aws.aws_cloudfront"
  domain_name = "${var.site_domain}"
  subject_alternative_names = ["*.${var.site_domain}"]
  validation_method = "DNS"

  lifecycle {
      create_before_destroy = true
  }

}

resource "aws_route53_record" "acm_cert" {
  name    = "${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.terraform_s3_route53_zone.id}"
  records = ["${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}
resource "aws_acm_certificate_validation" "acm_cert" {
  provider = "aws.aws_cloudfront"
  certificate_arn         = "${aws_acm_certificate.acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.acm_cert.fqdn}"]
}