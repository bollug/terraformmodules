resource "aws_iam_role" "codebuildiamrole" {
  name = var.codebuildrolename

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
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = var.codebuildarns
}

resource "aws_security_group" "web-sg" {
  name = var.sgname
  vpc_id = var.vpcid
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
  
  tags = {
		Name = "codebuildsg"	
	
	}
}


resource "aws_codebuild_project" "buildproject" {
  name          = var.projectname
  service_role  = aws_iam_role.codebuildiamrole.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = var.priviledgedmodes
  }
  source {
    type   = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id = var.vpcid

    subnets = var.privatesub1
      # var.privatesub2,
    

    security_group_ids = [
      aws_security_group.web-sg.id
      
    ]
  }

}
