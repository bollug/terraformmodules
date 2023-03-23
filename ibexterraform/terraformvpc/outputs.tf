output "region" {
  value = var.region 
}

output "Project_Name" {
  value = var.Project_Name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public-subnet-1-id" {
  value = aws_subnet.public-subnet-1.id
}

output "public-subnet-2-id" {
  value = aws_subnet.public-subnet-2.id
}

output "public-subnet-3-id" {
  value = aws_subnet.public-subnet-3.id
}

output "private-subnet-1-id" {
  value = aws_subnet.private-subnet-1.id
}
output "private-subnet-2-id" {
  value = aws_subnet.private-subnet-2.id
}

output "private-subnet-3-id" {
  value = aws_subnet.private-subnet-3.id
}





