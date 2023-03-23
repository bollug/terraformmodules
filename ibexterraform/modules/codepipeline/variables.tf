variable "repositoryname" {
  description = "repository name"
  type        = string
}

variable "branchname" {
  description = "repository name"
  type        = string
}

# variable "codebuildarns" {
#  type        = list(string)
#  description = "managed arns"
# }

variable "projectname" {
  description = "repository name"
  type        = string
}

variable "cfbuckets" {
  description = "cfbuck name"
  type        = string
 }


variable "codepipelinearns" {
 type        = list(string)
 description = "managed arns"
}

variable "codepipelinerolename" {
  description = "codepipelinerole name"
  type        = string
}


variable "codepipelinename" {
  description = "pipelinename name"
  type        = string
}

variable "artifactbucketname" {
  description = "bucket name"
  type        = string
}

variable "ApplicationNameEb" {
  description = "application name"
  type        = string
}

variable "EnvironmentNameEb" {
  description = "envt name"
  type        = string
}

variable "envs" {
  description = "provider name"
  type        = string
 }

variable "environment" {
  description = "env name"
  type        = string
}

variable "auto_apply" {
  type    = bool
  default = true
  description = "Whether to automatically skip or create build stages based on true or false"
}

variable "clustername" {
  description = "cluster name"
  type        = string
 }

variable "servicename" {
  description = "service name"
  type        = string
 }

variable "filename" {
  description = "file name"
  type        = string
 }


