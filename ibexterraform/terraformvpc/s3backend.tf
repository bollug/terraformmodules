terraform {
  backend "s3" {
    bucket    = "terraformtfstatebucket-01"
    key       = "terraformvpc.tfstate"
    region    = "ap-northeast-1"
  }
}
