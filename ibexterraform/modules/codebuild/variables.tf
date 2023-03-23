variable "codebuildarns" {
 type        = list(string)
 description = "managed arns"
}

variable "codebuildrolename" {
  description = "codebuildrolename name"
  type        = string
}

variable "projectname" {
  description = "repository name"
  type        = string
}

variable "priviledgedmodes" {
  description = "priviledgedmodes"
  type        = string
}


variable "vpcid" {
  description = "vpcid"
  type        = string
}

variable "privatesub1" {
 type        = list(string)
 description = "privatesub1"
}

# variable "privatesub2" {
#   description = "privatesub2"
#   type        = list(string)
# }

variable "sgname" {
  description = "sg name"
  type        = string
}
