resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"
  namespace  = "kube-system"
}

locals {
  oidc               = split("/", var.oidc)[4]
  argocd_root_domain = join(".", slice(split(".", var.argocd_domain), 1, length(split(".", var.argocd_domain))))
}

resource "aws_acm_certificate" "argocd" {
  domain_name       = var.argocd_domain
  validation_method = "DNS"

  tags = var.tags
}

resource "aws_route53_record" "argocd_validation" {
  for_each = {
    for dvo in aws_acm_certificate.argocd.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "argocd" {
  certificate_arn         = aws_acm_certificate.argocd.arn
  validation_record_fqdns = [for record in aws_route53_record.argocd_validation : record.fqdn]
}

resource "aws_iam_policy" "external_dns" {
  name        = "${var.project}-external-dns"
  description = "Policy for ExternalDNS to manage Route53 records"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/${var.route53_zone_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role" "external_dns" {
  name               = "${var.project}-external-dns"
  description        = "IAM role for ExternalDNS"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${local.oidc}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${local.oidc}:aud": "sts.amazonaws.com",
          "oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${local.oidc}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
EOF

  tags = merge(var.tags, {
    Name = "${var.project}-external-dns"
  })
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}

resource "kubernetes_service_account_v1" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns.arn
    }
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.14.5"
  namespace  = "kube-system"

  values = [
    yamlencode({
      sources       = ["ingress"]
      domainFilters = [local.argocd_root_domain]
    })
  ]

  set = [
    {
      name  = "provider"
      value = "aws"
    },
    {
      name  = "policy"
      value = "upsert-only"
    },
    {
      name  = "registry"
      value = "txt"
    },
    {
      name  = "txtOwnerId"
      value = var.project
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account_v1.external_dns.metadata[0].name
    }
  ]

  depends_on = [
    kubernetes_service_account_v1.external_dns
  ]
}

resource "kubernetes_namespace_v1" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "aws_iam_policy" "external_secrets" {
  name        = "${var.project}-external-secrets"
  description = "Policy for External Secrets Operator to read AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "external_secrets" {
  name               = "${var.project}-external-secrets"
  description        = "IAM role for External Secrets Operator"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${local.oidc}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${local.oidc}:aud": "sts.amazonaws.com",
          "oidc.eks.${data.aws_region.current.region}.amazonaws.com/id/${local.oidc}:sub": "system:serviceaccount:external-secrets:external-secrets"
        }
      }
    }
  ]
}
EOF

  tags = merge(var.tags, {
    Name = "${var.project}-external-secrets"
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets.name
  policy_arn = aws_iam_policy.external_secrets.arn
}

resource "kubernetes_service_account_v1" "external_secrets" {
  metadata {
    name      = "external-secrets"
    namespace = "external-secrets"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets.arn
    }
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.10.4"
  namespace  = "external-secrets"
  wait       = true
  timeout    = 600

  set = [
    {
      name  = "installCRDs"
      value = "true"
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = kubernetes_service_account_v1.external_secrets.metadata[0].name
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.external_secrets,
    kubernetes_service_account_v1.external_secrets
  ]
}

resource "kubernetes_manifest" "external_secrets_cluster_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "aws-secrets-manager"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = data.aws_region.current.id
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = "external-secrets"
                namespace = "external-secrets"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.external_secrets
  ]
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "random_password" "argocd_server_secretkey" {
  length  = 32
  special = false
}

resource "helm_release" "argocd" {
  name         = "argocd"
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argo-cd"
  version      = "9.0.0"
  namespace    = "argocd"
  force_update = true
  wait         = false
  timeout      = 600

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
      }
      configs = {
        secret = {
          createSecret = true
          argocdServerSecretkey = random_password.argocd_server_secretkey.result
        }
        cm = {
          url                  = "https://${var.argocd_domain}"
          "accounts.terraform" = "apiKey, login"
        }
        params = {
          "server.insecure" = "true"
        }
        rbac = {
          "policy.csv" = "g, terraform, role:admin"
        }
      }
      server = {
        extraArgs = ["--insecure"]
        ingress = {
          hosts = [
            {
              host  = var.argocd_domain
              paths = ["/"]
            }
          ]
        }
      }
    })
  ]

  set = [
    {
      name  = "server.service.type"
      value = "ClusterIP"
    },
    {
      name  = "server.insecure"
      value = "true"
    },
    {
      name  = "server.ingress.enabled"
      value = "true"
    },
    {
      name  = "server.ingress.ingressClassName"
      value = "alb"
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
      value = "internet-facing"
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
      value = "ip"
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"
      value = "[{\"HTTPS\":443}]"
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/ssl-redirect"
      value = "443"
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/healthcheck-path"
      value = "/"
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/certificate-arn"
      value = aws_acm_certificate_validation.argocd.certificate_arn
    },
    {
      name  = "server.ingress.annotations.alb\\.ingress\\.kubernetes\\.io/backend-protocol"
      value = "HTTP"
    },
    {
      name  = "server.ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
      value = var.argocd_domain
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd,
    aws_acm_certificate_validation.argocd
  ]
}
