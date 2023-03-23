#VPC Variables
variable "region" {
  description   = "AWS Region"
  type          = string
}

variable "vpc-cidr" {
  description   = "VPC CIDR Block"
  type          = string
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
}

variable "Project_Name" {
  description   = "Projectname"
  type          = string
}