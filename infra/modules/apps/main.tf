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
        "alb.ingress.kubernetes.io/group.name"        = var.apps_alb_group_name
        "alb.ingress.kubernetes.io/scheme"            = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"       = "ip"
        "alb.ingress.kubernetes.io/listen-ports"      = "[{\"HTTPS\":443}]"
        "alb.ingress.kubernetes.io/ssl-redirect"      = "443"
        "alb.ingress.kubernetes.io/backend-protocol"  = "HTTP"
        "alb.ingress.kubernetes.io/healthcheck-path"  = "/health"
        "alb.ingress.kubernetes.io/certificate-arn"   = var.apps_certificate_arn
        "external-dns.alpha.kubernetes.io/hostname"   = var.apps_domain
      }
    }
    spec = {
      ingressClassName = "alb"
      rules = [
        {
          host = var.apps_domain
          http = {
            paths = [
              {
                path     = each.value.path_prefix
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
