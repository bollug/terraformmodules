# Create EB
provider "aws" {
  region = var.region
}

data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:my_secrety_name-123456"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}



resource "aws_elastic_beanstalk_application" "elasticbeanstalkapp" {
  name = var.applicationname
}

resource "aws_elastic_beanstalk_application_version" "appversion" {
  name        = var.versionlabelname
  application = aws_elastic_beanstalk_application.elasticbeanstalkapp.name
  description = "application version created by terraform"
  bucket      = var.bucketname
  key         = var.bucketkey
}

resource "aws_elastic_beanstalk_configuration_template" "eb_template" {
  name                = var.templatename
  application         = aws_elastic_beanstalk_application.elasticbeanstalkapp.name
  solution_stack_name = var.stackname
}

resource "aws_elastic_beanstalk_environment" "ebenvtest" {
  name                = var.envname
  application         = aws_elastic_beanstalk_application.elasticbeanstalkapp.name
  solution_stack_name = var.stackname
  version_label       = aws_elastic_beanstalk_application_version.appversion.name

  dynamic "setting" {
    for_each = var.environment
    content {
      namespace = setting.value.namespace
      name      = setting.value.name
      value     = setting.value.value
    }
  }  

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.ebiam_role.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2.name
  }

  # dynamic "setting" {
  #   for_each = var.asglc
  #   content {
  #     namespace = "aws:autoscaling:launchconfiguration"
  #     name      = setting.value.name
  #     value     = setting.value.value
  #   }
  # }  

  # dynamic "setting" {
  #   for_each = var.asgcount
  #   content {
  #     namespace = "aws:autoscaling:asg"
  #     name      = setting.value.name
  #     value     = setting.value.value
  #   }
  # } 

}

resource "aws_iam_role" "ebiam_role" {
  name = "service_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { 
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}

resource "aws_iam_role" "ebec2iam_role" {
  name = "instance_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}

resource "aws_iam_instance_profile" "beanstalk_ec2" {
  name = "instanceprofile"
  role = "${aws_iam_role.ebec2iam_role.name}"
}












