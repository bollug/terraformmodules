terraform {
  backend "s3" {
    bucket    = "statefiles-01"
    key       = "codepippeline.tfstate"
    region    = "us-east-1"
  }
}