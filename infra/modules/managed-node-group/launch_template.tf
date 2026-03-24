resource "aws_launch_template" "eks_node_group" {
  name_prefix = "${var.prefix}-eks-node-group-launch-template-"
  metadata_options {
    http_put_response_hop_limit = 2
  }
}
