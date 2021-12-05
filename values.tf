locals {
  k8s_role_create          = length(var.k8s_role_arn) == 0 ? true : false
  k8s_irsa_role_create     = var.enabled && var.k8s_rbac_create && var.k8s_service_account_create && local.k8s_role_create
  k8s_service_account_name = "${var.helm_chart_name}-${var.helm_release_name}"
  values = yamlencode({
    rbac : {
      create : var.k8s_rbac_create
    }
    prometheus : {
      serviceAccount : {
        create : var.k8s_service_account_create
        name : local.k8s_service_account_name
        annotations : {
          "eks.amazonaws.com/role-arn" : local.k8s_irsa_role_create ? aws_iam_role.this[0].arn : var.k8s_role_arn
        }
      }
    }
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values,
    var.values
  ])
}
