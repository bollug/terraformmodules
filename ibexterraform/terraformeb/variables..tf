#EB Variables
variable "region" {
  description = "AWS Region"
  type        = string
}

variable "applicationname" {
  description = "application name eb"
  type        = string
}

variable "templatename" {
  description = "application name eb"
  type        = string
}

variable "stackname" {
  description = "application name eb"
  type        = string
}

variable "envname" {
  description = "env name eb"
  type        = string
}

variable "versionlabelname" {
  description = "application version name"
  type        = string
}

variable "bucketname" {
  description = "bucket name eb"
  type        = string
}

variable "bucketkey" {
  description = "bucket key eb"
  type        = string
}



variable "environment" {

  description = "list of values to assign to subnets"

  type = list(object({
   
    namespace = string
   
    name      = string

    value     = string

  }))

}

# variable "asglc" {

#   description = "list of values to assign to subnets"

#   type = list(object({

#     name     = string

#     value    = string

#   }))

# }

# variable "asgcount" {

#   description = "list of values to assign to subnets"

#   type = list(object({

#     name     = string

#     value    = string

#   }))

#}







