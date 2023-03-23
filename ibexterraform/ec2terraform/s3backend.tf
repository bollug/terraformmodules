terraform {
  backend "s3" {
    bucket    = "terraformtfstatebucket-01"
    key       = "terraformec2.tfstate"
    region    = "ap-northeast-1"
  }
}
