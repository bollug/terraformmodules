# Create EB
provider "aws" {
  region = var.region
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
  application         = var.applicationname
  solution_stack_name = var.stackname
}

resource "aws_elastic_beanstalk_environment" "ebenvtest" {
  name                = var.envname
  application         = aws_elastic_beanstalk_application.elasticbeanstalkapp.name
  solution_stack_name = var.stackname
  version_label       = aws_elastic_beanstalk_application_version.appversion.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = var.load_balancer_type
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.ebiam_role.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = var.environment_type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2.name
  }

  setting {
    name      = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = var.aws_key_pair_name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.asg_min_count
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.asg_max_count
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     =  var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     =  join(",",var.private_subnet_ids)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBsubnets"
    value     =  join(",",var.public_subnet_ids)
  }
  setting {
    namespace = "aws:elb:loadbalancer"         
    name      = "ManagedSecurityGroup"
    value     =  aws_security_group.lb-sg.name
  }  

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
    
  }
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

resource "aws_security_group" "lb-sg" {
  name = "loadbalancersg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}











