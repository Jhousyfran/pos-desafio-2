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

resource "kubernetes_manifest" "apps_ingress" {
  for_each = local.apps_by_name

  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "${each.value.name}-ingress"
      namespace = each.value.namespace
      annotations = {
        "nginx.ingress.kubernetes.io/use-regex"          = "true"
        "nginx.ingress.kubernetes.io/rewrite-target"     = "/$2"
        "nginx.ingress.kubernetes.io/proxy-read-timeout" = "60"
        "nginx.ingress.kubernetes.io/proxy-send-timeout" = "60"
        "external-dns.alpha.kubernetes.io/hostname"      = var.apps_domain
      }
    }
    spec = {
      ingressClassName = var.ingress_class_name
      rules = [
        {
          host = var.apps_domain
          http = {
            paths = [
              {
                path     = "${each.value.path_prefix}(/|$)(.*)"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = each.value.name
                    port = {
                      number = each.value.port
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }

  depends_on = [
    kubernetes_namespace_v1.apps
  ]
}
