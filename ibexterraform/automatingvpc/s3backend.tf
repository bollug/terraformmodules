terraform {
  backend "s3" {
    bucket    = "terraformtfstatebucket-01"
    key       = "automatingvpc.tfstate"
    region    = "ap-northeast-1"
  }
}