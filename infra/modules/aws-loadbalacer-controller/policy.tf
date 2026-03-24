resource "aws_iam_policy" "eks_controller_policy" {
  name        = "${var.prefix}-eks_controller_policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy.json")

  tags = merge(var.tags, {
    Name = "${var.prefix}-eks-controller-policy"
  })
}
