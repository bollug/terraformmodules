output "servicerole" {
  value  =  aws_iam_role.ebiam_role
}

output "instanceprofile" {
  value  = aws_iam_instance_profile.beanstalk_ec2
}

output "applicationname" {
  value  = aws_elastic_beanstalk_application.elasticbeanstalkapp

}

output "environmentname" {
  value  = aws_elastic_beanstalk_environment.ebenvtest
}



