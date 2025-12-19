data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = var.trusted_role_actions

    principals {
      type        = "AWS"
      identifiers = var.trusted_role_arns
    }

    principals {
      type        = "Service"
      identifiers = var.trusted_role_services
    }
  }
}

resource "aws_iam_role_policy" "this" {

  name        = var.policy_name
  role        = aws_iam_role.this.id
  policy      = var.policy
}

resource "aws_iam_role" "this" {
  name                 = var.role_name
  path                 = var.role_path
  description          = var.role_description
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = var.managed_policy_arns
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.role_name
  path = var.role_path
  role = aws_iam_role.this.name
}
