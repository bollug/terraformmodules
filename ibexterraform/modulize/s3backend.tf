terraform {
  backend "s3" {
    bucket = "terraformstatefiles-099"
    key    = "modulizes.tfstate"
    region = "us-east-1"
  }
}