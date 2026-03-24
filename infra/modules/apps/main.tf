locals {
  apps_by_name = { for app in var.apps : app.name => app }
}

resource "kubernetes_namespace_v1" "apps" {
  for_each = local.apps_by_name

  metadata {
    name = each.value.namespace
  }
}

resource "argocd_application" "apps" {
  for_each = local.apps_by_name

  metadata {
    name      = each.value.name
    namespace = "argocd"
  }

  spec {
    project = var.argocd_project

    source {
      repo_url        = var.argocd_repo_url
      path            = each.value.path
      target_revision = var.target_revision
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = each.value.namespace
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }

  depends_on = [
    kubernetes_namespace_v1.apps
  ]
}
