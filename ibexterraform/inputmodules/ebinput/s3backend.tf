terraform {
  backend "s3" {
    bucket    = "statefiles-01"
    key       = "eb.tfstate"
    region    = "us-east-1"
  }
}