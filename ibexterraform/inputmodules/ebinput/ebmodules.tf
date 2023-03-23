# Create EB
provider "aws" {
  region = "us-east-1"
}

data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:447866558052:secret:databasecredentials-FCJb3y"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

module "eb" {
  source             = "../../modules/testeb"
  region             = "us-east-1"
  applicationname    = "ElasticBeanstalk2"
  versionlabelname   = "eb-label-1"
  templatename       = "ebtemplate"
  stackname          = "64bit Amazon Linux 2 v5.6.4 running Node.js 16"
  bucketname         = "bucketebsource-01"
  bucketkey          = "cloudformebtest.zip"
  envname            = "ebenvv"
  environment        = [
    {namespace = "aws:elasticbeanstalk:environment" , name = "EnvironmentType" , value = "LoadBalanced"},
    {namespace = "aws:elasticbeanstalk:environment", name = "LoadBalancerType" , value = "application" },
    {namespace = "aws:elasticbeanstalk:environment", name = "ServiceRole" , value = module.eb.servicerole.name},  
    {namespace = "aws:autoscaling:launchconfiguration", name = "EC2KeyName" , value = "terraform"},
    {namespace = "aws:autoscaling:launchconfiguration" ,name = "InstanceType" , value = "t2.micro"},
    {namespace = "aws:autoscaling:launchconfiguration" ,name = "IamInstanceProfile" , value = module.eb.instanceprofile.name},
    {namespace = "aws:autoscaling:asg",name = "MinSize" , value = "1"},
    {namespace = "aws:autoscaling:asg",name = "MaxSize" , value = "2"},
    {namespace = "aws:ec2:vpc",name = "VPCId" , value = module.vpc.vpc_id},
    {namespace = "aws:ec2:vpc",name = "Subnets" , value = join(",",module.vpc.private_subnet_ids)},
    {namespace = "aws:ec2:vpc",name = "ELBsubnets" , value = join(",",module.vpc.public_subnet_ids)},
    {namespace = "aws:elasticbeanstalk:application:environment", name = "RDS_HOSTNAME" , value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["RDS_HOSTNAME"]},
    {namespace = "aws:elasticbeanstalk:application:environment",name = "RDS_USERNAME" , value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["RDS_USERNAME"]},
    {namespace = "aws:elasticbeanstalk:application:environment",name = "RDS_PASSWORD" , value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["RDS_PASSWORD"]},
    {namespace = "aws:elasticbeanstalk:application:environment",name = "RDS_DB_NAME" , value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["RDS_DB_NAME"]},
    {namespace = "aws:elasticbeanstalk:application:environment",name = "Port" , value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["Port"]}
   

  ] 

}

module "vpc" {
  source   = "../../modules/vpc"
  region                 = "us-east-1"
  vpc-cidr               = "10.0.0.0/16"
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  azs                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  Project_Name           = "projectvpc"
}

