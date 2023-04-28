output "ssm_automation_document_arn" {
  value       = aws_ssm_document.main.arn
  description = "created ssm document arn"
}

output "ssm_automation_document_name" {
  value       = aws_ssm_document.main.name
  description = "created ssm document name"
}
