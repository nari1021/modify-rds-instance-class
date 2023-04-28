data "template_file" "ssm" {
  template = file("${path.module}/ModifyRDSInstanceClass.yaml")
  vars = {
    "iam_role" = aws_iam_role.ssm.arn
  }
}

resource "aws_ssm_document" "main" {
  name            = "ModifyRDSInstanceClass"
  document_format = "YAML"
  document_type   = "Automation"

  content = data.template_file.ssm.rendered
}
