#cloudfront.tf

locals {
    #cloudfrontの配信元の識別子
  s3_origin_id = "${var.site_domain}"

}

resource "aws_cloudfront_origin_access_identity" "site" {
  #バケットが作成されてからcloudfrontのインスタンスを作成する。依存関係を定義
  depends_on = [
    "aws_s3_bucket.site",
  ]

  # PrivateなS3 Bucketにアクセスするためにオリジンアクセスアイデンティティを利用する
  comment = "${var.site_domain}"
}

resource "aws_cloudfront_distribution" "site" {
  
  origin {
    domain_name = "${aws_s3_bucket.site.bucket_regional_domain_name}"
    origin_id   = "${local.s3_origin_id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.site.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.site_domain}"
  default_root_object = "index.html"

  aliases = ["${var.site_domain}"]
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  
  # Route53&ACM設定が終わった後で、独自ドメインの証明書に変更
  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate_validation.acm_cert.certificate_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }


}