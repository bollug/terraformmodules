region             = "us-east-1"
applicationname    = "ElasticBeanstalks"
versionlabelname   = "eb-label-1"
templatename       = "ebtemplates"
stackname          = "64bit Amazon Linux 2 v5.6.4 running Node.js 16"
bucketname         = "bucketebsource-01"
bucketkey          = "cloudformebtest.zip"
envname            = "ebenvv"
environment        = [
  {namespace = "aws:elasticbeanstalk:environment" , name = "EnvironmentType" , value = "LoadBalanced"},
  {namespace = "aws:elasticbeanstalk:environment", name = "LoadBalancerType" , value = "application" },
  {namespace = "aws:elasticbeanstalk:environment", name = "ServiceRole" , value = module. },  
  {namespace = "aws:autoscaling:launchconfiguration", name = "EC2KeyName" , value = "terraform"},
  {namespace = "aws:autoscaling:launchconfiguration" ,name = "InstanceType" , value = "t2.micro"},
  {namespace = "aws:autoscaling:asg",name = "MinSize" , value = "1"},
  {namespace = "aws:autoscaling:asg",name = "MaxSize" , value = "2"},
  {namespace = "aws:ec2:vpc",name = "VPCId" , value = "vpc-09e827d115702a279"},
  {namespace = "aws:ec2:vpc",name = "Subnets" , value = "subnet-00ebf868cfa6546b6"},
  {namespace = "aws:ec2:vpc",name = "Subnets" , value = "subnet-0707c343d648cada0"},
  {namespace = "aws:ec2:vpc",name = "Subnets" , value = "subnet-08c672c4e21a94600"},
  {namespace = "aws:ec2:vpc",name = "ELBsubnets" , value = "subnet-05f804a9f6f7fb659"},
  {namespace = "aws:ec2:vpc",name = "ELBsubnets" , value = "subnet-0496563b1b33644c4"},
  {namespace = "aws:ec2:vpc",name = "ELBsubnets" , value = "subnet-0b2434f081b9cadae"}
] 
# asglc              = [
#   {name = "EC2KeyName" , value = "terraform"},
#   {name = "InstanceType" , value = "t2.micro"}
# ]
# asgcount           = [
#   {name = "MinSize" , value = "1"},
#   {name = "MaxSize" , value = "2"}
# ]
