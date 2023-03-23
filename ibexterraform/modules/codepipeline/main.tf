# creating s3 Bucket
resource "aws_s3_bucket" "codepipelineartifact_bucket" {
  bucket = var.artifactbucketname
}

# resource "aws_s3_bucket" "cf_bucket" {
#   count    = "${var.environment == "cf" ? 1 : 0}"
#   bucket   = var.cfbucket
# }

# codeipelinerole
resource "aws_iam_role" "codepipelineservicerole" {
  name = var.codepipelinerolename

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
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = var.codepipelinearns
}

# creating codepipeline
resource "aws_codepipeline" "codepipeline" {
  name     = var.codepipelinename
  role_arn = aws_iam_role.codepipelineservicerole.arn

  artifact_store {
    location = var.artifactbucketname
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName  = var.repositoryname
        BranchName      = var.branchname
        
      }
    }
  }

  
  dynamic "stage" {
    for_each = ! var.auto_apply ? [1] : []
    content {
      name = "Build"

      action {
        name             = "Build"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        input_artifacts  = ["source_output"]
        output_artifacts = ["build_output"]
        version          = "1"
        configuration    = {
          ProjectName    = var.projectname
      }
    }
  }
}
  

  
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = var.envs
      input_artifacts = "${var.environment == "eb" ? ["source_output"] : ["build_output"]}"
      version         = "1"

      configuration = {
        ApplicationName = "${var.environment == "eb" ? var.ApplicationNameEb : null}"
        EnvironmentName = "${var.environment == "eb" ? var.EnvironmentNameEb : null}"
        BucketName      = "${var.environment == "cf" ? var.cfbuckets : null}"
        Extract         = "${var.environment == "cf" ? "true" : null}"
        ClusterName     = "${var.environment == "ecs" ? var.clustername : null}"
        ServiceName     = "${var.environment == "ecs" ? var.servicename : null}"
        FileName        = "${var.environment == "ecs" ? var.filename : null}"
      }
    }
  }
}



