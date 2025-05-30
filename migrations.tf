moved {
  from = aws_iam_role.this[0]
  to   = module.addon-irsa["prometheus"].aws_iam_role.this[0]
}

moved {
  from = aws_iam_policy.this[0]
  to   = module.addon-irsa["prometheus"].aws_iam_policy.this[0]
}

moved {
  from = aws_iam_role_policy_attachment.this[0]
  to   = module.addon-irsa["prometheus"].aws_iam_role_policy_attachment.this[0]
}

moved {
  from = kubernetes_manifest.this[0]
  to   = module.addon.kubernetes_manifest.this[0]
}

moved {
  from = helm_release.this[0]
  to   = module.addon.helm_release.this[0]
}

moved {
  from = helm_release.argo_application[0]
  to   = module.addon.helm_release.argo_application[0]
}

moved {
  from = kubernetes_job.helm_argo_application_wait
  to   = module.addon.kubernetes_job.helm_argo_application_wait
}

moved {
  from = kubernetes_role.helm_argo_application_wait
  to   = module.addon.kubernetes_role.helm_argo_application_wait
}

moved {
  from = kubernetes_role_binding.helm_argo_application_wait
  to   = module.addon.kubernetes_role_binding.helm_argo_application_wait
}

moved {
  from = kubernetes_service_account.helm_argo_application_wait
  to   = module.addon.kubernetes_service_account.helm_argo_application_wait
}
