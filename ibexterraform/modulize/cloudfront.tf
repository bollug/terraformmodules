module "cf" {
  source               = "../modules/cloudfront"
  cloudfrontbucketname = "cloudfrontbuuckets-0976678.s3.amazonaws.com"
  #   domainname           = "cft.cleanworld.ml"
  accountid    = "794605155433"
  hostedzoneid = "Z0739312H5IHFGYQ2C3I"
  cfbucket     = "cloudfrontbuuckets-0976678"
}

