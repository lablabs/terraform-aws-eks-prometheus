/**
 * # AWS EKS Prometheus Operator Terraform module
 *
 * A Terraform module to deploy the [Prometheus](https://prometheus.io/) operator on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-prometheus/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-prometheus/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-prometheus/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-prometheus/actions/workflows/pre-commit.yaml)
*/
locals {
  addon = {
    name      = "kube-prometheus-stack"
    namespace = "prometheus"

    helm_repo_url      = "https://prometheus-community.github.io/helm-charts"
    helm_chart_version = "75.13.0"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    global = {
      rbac = {
        create = module.addon-irsa[local.addon.name].rbac_create
      }
    }

    prometheus = {
      serviceAccount = {
        create = module.addon-irsa[local.addon.name].service_account_create
        name   = module.addon-irsa[local.addon.name].service_account_name
        annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
        } : tomap({})
      }
    }
  })

  addon_depends_on = []
}
