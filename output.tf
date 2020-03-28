# 作成されたCloudFront Destributionのドメインを出力
output "cloud_front_destribution_domain_name" {
  value = "${aws_cloudfront_distribution.site.domain_name}"
}

output "zone_name_servers" {
  value = "${aws_route53_zone.terraform_s3_route53_zone.name_servers}"
}