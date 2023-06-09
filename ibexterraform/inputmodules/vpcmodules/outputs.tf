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