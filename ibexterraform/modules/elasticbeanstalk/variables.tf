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

variable "load_balancer_type" {
  description = "bucket key eb"
  type        = string
}

variable "environment_type" {
  description = "bucket key eb"
  type        = string
}

variable "asg_min_count" {
  description = "asgmin eb"
  type        = string
}

variable "asg_max_count" {
  description = "asgmax eb"
  type        = string
}

variable "instance_type" {
  description = "instancetype eb"
  type        = string
}

variable "aws_key_pair_name" {
  description = "keypair eb"
  type        = string
}

variable "vpc_id" {
  description = "vpcid"
  type        = string
}
variable "private_subnet_ids" {
  description = "privsub"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "pubsub"
  type        = list(string)
}