provider "aws" {
    version = "2.40.0"
    region = "ap-northeast-1"
}

# ACMをssl証明書として使う場合us-east-1で作成する必要があるため、
# us-east-1用のaws providerを定義しておく
provider "aws" {
# us-east-1 
    version = "2.40.0"
    region = "us-east-1"
    alias = "aws_cloudfront"
}

terraform {
    required_version = "0.12.6"
    backend "s3" {
        bucket = "terraform-backend-2020-02"
        key = "terraform-s3-route53-cloudfront/terraform.tfstate"
        region = "ap-northeast-1"
    }
}



