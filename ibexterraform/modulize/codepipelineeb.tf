# Configure the AWS Provider
module "codecommit" {

  source         = "../modules/codecommit"
  repositoryname = "ebcode"
  branchname     = "master"

}

module "codebuild" {
  count             = var.createcodebuild == "yes" ? 1 : 0
  source            = "../modules/codebuild"
  codebuildarns     = ["arn:aws:iam::aws:policy/AWSCodeCommitFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess", "arn:aws:iam::aws:policy/CloudFrontFullAccess", "arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk", "arn:aws:iam::aws:policy/AmazonECS_FullAccess", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"]
  codebuildrolename = "buildrole"
  projectname       = "codebuild"
  priviledgedmodes  = true
  vpcid             = module.vpc.vpc_id
  privatesub1       = [module.vpc.private_subnet_id1, module.vpc.private_subnet_id2, module.vpc.private_subnet_id3]
  sgname            = "codebuildsgg"
}

module "codepipelineeb" {
  source               = "../modules/codepipeline"
  repositoryname       = module.codecommit.RepositoryName
  branchname           = module.codecommit.Branchname
  codepipelinerolename = "pipelinerole"
  codepipelinearns     = ["arn:aws:iam::aws:policy/AWSCodeCommitPowerUser", "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess", "arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonECS_FullAccess"]
  codepipelinename     = "myecs"
  artifactbucketname   = "artifactingbucket-096"
  ApplicationNameEb    = "ElasticBeanstalk2"
  EnvironmentNameEb    = "ebenvv"
  envs                 = "ECS"
  environment          = "ecs"
  cfbuckets            = module.cf.cloudfrontbuckets
  projectname          = "codebuild"
  auto_apply           = false
  clustername          = module.ecss.clustername
  servicename          = module.ecss.servicename
  filename             = "imagedefinitions.json"

}

# module "codepipelinecf" {
#   count                 = "${var.createcfpipeline == "yes" ? 1 : 0}"
#   source                = "../modules/codepipeline"
#   repositoryname        = module.codecommit.RepositoryName
#   branchname            = module.codecommit.Branchname
#   codepipelinerolename  = "pipelinerolecff"
#   codepipelinearns      = ["arn:aws:iam::aws:policy/AWSCodeCommitPowerUser" , "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess" , "arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess" , "arn:aws:iam::aws:policy/CloudWatchFullAccess" , "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess" , "arn:aws:iam::aws:policy/AmazonEC2FullAccess" , "arn:aws:iam::aws:policy/CloudFrontFullAccess" , "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
#   codepipelinename      = "mycff"
#   artifactbucketname    = "artifactingbucketcf-09667"
#   envs                  = "S3"
#   environment           = "cf"
#   cfbucket              = "cfbucket-09976"
#   ApplicationNameEb     = "${var.environmentpipeline == "use" ? "execute" : null}"
#   EnvironmentNameEb     = "${var.environmentpipeline == "use" ? "executes" : null}"
#   projectname           = "codebuild"
#   auto_apply            = false

# }




