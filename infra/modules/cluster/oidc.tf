data "tls_certificate" "eks_cluster" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = data.tls_certificate.eks_cluster.url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = data.tls_certificate.eks_cluster.certificates[*].sha1_fingerprint

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-oidc-provider"
    }
  )
}
