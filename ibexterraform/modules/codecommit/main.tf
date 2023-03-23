#creating codecommit repo
resource "aws_codecommit_repository" "codecommit" {
  repository_name =  var.repositoryname
  default_branch  =  var.branchname
  description     = "This is the code commit Repository"
}