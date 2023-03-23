variable "vpcid" {
  description = "vpcid"
  type        = string
}

variable "private_subnet_ids" {
  description = "subid"
  type        = list(string)
}

variable "publicsubnetsids" {
  description = "subid"
  type        = list(string)
}

variable "containername" {
  description = "contname"
  type        = string
}

variable "contsg" {
  description = "contsg"
  type        = string
}

variable "lbsg" {
  description = "lbsg"
  type        = string
}

variable "domainname" {
  description = "domainame"
  type        = string
}

variable "hostedzoneid" {
  description = "id"
  type        = string
}