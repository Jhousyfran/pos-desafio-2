output "apps_certificate_arn" {
  description = "ARN do certificado ACM para o host das apps"
  value       = aws_acm_certificate_validation.apps.certificate_arn
}
