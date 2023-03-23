output "region" {
  value = var.region 
}

output "Project_Name" {
  value = var.Project_Name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = aws_subnet.public_subnets.*.id
}

output "private_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = aws_subnet.private_subnets.*.id
}


output "private_subnet_id1" {
  value = element(aws_subnet.private_subnets.*.id, 1)
}


output "private_subnet_id2" {
  value = element(aws_subnet.private_subnets.*.id, 2)
}


output "private_subnet_id3" {
  value = element(aws_subnet.private_subnets.*.id, 3)

}

output "public_subnet_id1" {
  value = element(aws_subnet.public_subnets.*.id, 1)
}


output "public_subnet_id2" {
  value = element(aws_subnet.public_subnets.*.id, 2)
}


output "public_subnet_id3" {
  value = element(aws_subnet.public_subnets.*.id, 3)

}

