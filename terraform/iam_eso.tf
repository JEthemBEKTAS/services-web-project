variable "eks_oidc_provider_arn" { type = string }  # exporté par ton module EKS
variable "eks_oidc_provider_url" { type = string }  # ex: oidc.eks.<region>.amazonaws.com/id/<id>
variable "account_id"            { type = string }  # data.aws_caller_identity.current.account_id

# Policy lecture limitée aux 2 ARNs
data "aws_iam_policy_document" "eso_read_secrets" {
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.app_db.arn,
      aws_secretsmanager_secret.app_salts.arn
    ]
  }
}

resource "aws_iam_policy" "eso_read_secrets" {
  name   = "${var.project}-eso-read-secrets"
  policy = data.aws_iam_policy_document.eso_read_secrets.json
}

# Trust policy pour le SA `eso` (ns: external-secrets)
data "aws_iam_policy_document" "eso_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-secrets:eso"]
    }
  }
}

resource "aws_iam_role" "eso_irsa_role" {
  name               = "${var.project}-eso-irsa"
  assume_role_policy = data.aws_iam_policy_document.eso_trust.json
}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso_irsa_role.name
  policy_arn = aws_iam_policy.eso_read_secrets.arn
}

output "eso_irsa_role_arn" { value = aws_iam_role.eso_irsa_role.arn }
