# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "codecommit" {
 
  source            =  "../../../modules/codecommit"
  repositoryname    = "ebcode"
  branchname        = "master"

}

module "codepipeline" {

   source                =  "../../../modules/codepipeline"
   repositoryname        = module.codecommit.RepositoryName
   branchname            = module.codecommit.Branchname
   codepipelinerolename  = "pipelinerole"
   codepipelinearns      = ["arn:aws:iam::aws:policy/AWSCodeCommitPowerUser" , "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess" , "arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess" , "arn:aws:iam::aws:policy/CloudWatchFullAccess" , "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess" , "arn:aws:iam::aws:policy/AmazonEC2FullAccess" , "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk"]
   codepipelinename      = "myeb"
   artifactbucketname    = "artifactingbucket-096"
   ApplicationNameEb     = "ElasticBeanstalk2"
   EnvironmentNameEb     = "ebenvv"

}
  

  
