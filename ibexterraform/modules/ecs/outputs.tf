output "clustername" {
  value       = aws_ecs_cluster.cluster.name
}

output "servicename" {
  value       = aws_ecs_service.service.name
}