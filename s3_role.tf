locals {
  object_name          = "${module.label.namespace}-${module.label.environment}-${module.label.stage}-${module.label.name}"
}

data "aws_iam_policy_document" "prometheus" {
  count = var.enabled && var.thanos_s3_iam_role ? 1 : 0
  statement {
    sid     = "FullObjectStorePermissions"
    effect  = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [var.thanos_s3_arn, "${var.thanos_s3_arn}/*"]
  }

  statement {
    sid = "KMS"
    actions = [
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = var.kms_key_arn
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "prometheus" {
  count       = var.enabled && var.thanos_s3_iam_role ? 1 : 0
  name        = "${local.object_name}-prometheus-policy"
  path        = "/"
  description = "Policy for prometheus service account"

  policy = data.aws_iam_policy_document.prometheus[0].json
}

data "aws_iam_policy_document" "prometheus_assume" {
  count = var.enabled && var.thanos_s3_iam_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.k8s_namespace}:${var.prometheus_k8s_service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "prometheus" {
  count              = var.enabled && var.thanos_s3_iam_role ? 1 : 0
  name               = "${local.object_name}-prometheus-role"
  assume_role_policy = data.aws_iam_policy_document.prometheus_assume[0].json
  tags               = module.label.tags
}

resource "aws_iam_role_policy_attachment" "prometheus" {
  count      = var.enabled && var.thanos_s3_iam_role ? 1 : 0
  role       = aws_iam_role.prometheus[0].name
  policy_arn = aws_iam_policy.prometheus[0].arn
}

output "prometheus_sa_role_arn" {
  value       = aws_iam_role.prometheus[0].arn
  description = "Prometheus Service Account role ARN"
}