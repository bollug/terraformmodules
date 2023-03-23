resource "aws_s3_bucket" "cf_bucket" {
  bucket   = var.cfbucket
}


resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "sample"
  description                       = "oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  
  origin {
    domain_name              = var.cloudfrontbucketname
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "staticweb-hostings"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["cftt.cleanworld.ml"]

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:794605155433:certificate/05366ec7-e04c-4669-9776-47d8edead320"  
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       =  "sni-only"
  }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "staticweb-hostings"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

# resource "aws_iam_policy" "policys" {
#   name        = "s3bucketpolicys"
#   description = "My test policy"

#   policy = <<EOT
# # {
# #     "Version": "2012-10-17",
# #     "Statement": [{
# #         "Sid": "AllowCloudFrontServicePrincipalReadWrite",
# #         "Effect": "Allow",
# #         "Principal": {
# #             "Service": "cloudfront.amazonaws.com"
# #         },
# #         "Action": [
# #             "s3:GetObject",
# #             "s3:PutObject"
# #         ],
# #         "Resource": "arn:aws:s3:::${var.cfbucket}/*",
# #         "Condition": {
# #             "StringEquals": {
# #                 "AWS:SourceArn": "arn:aws:cloudfront::${var.accountid}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
# #             }
# #         }
# #     }]
# # }

# EOT
# }

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.cf_bucket.id
  policy = jsonencode({
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${var.cfbucket}/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "arn:aws:cloudfront::${var.accountid}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                    }
                }
            }
        ]
      })
}



resource "aws_route53_record" "www" {
  zone_id = var.hostedzoneid
  name    = "cftt.cleanworld.ml"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.s3_distribution.domain_name]
}