output "prometheus_sa_role_arn" {
  value       = try(aws_iam_role.prometheus[0].arn, {})
  description = "Prometheus Service Account role ARN"
}
