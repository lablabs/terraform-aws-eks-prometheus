locals {
  values = yamlencode({
    prometheus : {
      serviceAccount : {
        annotations : {
          "eks.amazonaws.com/role-arn" : "${aws_iam_role.prometheus[0].arn}"
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
