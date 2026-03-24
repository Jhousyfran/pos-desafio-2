resource "aws_elasticache_subnet_group" "default" {
  name       = "redis-cache-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "default" {
  for_each             = { for cache in var.cache_config : cache.name => cache }
  cluster_id           = "${each.value.name}-cluster"
  engine               = each.value.engine
  node_type            = each.value.node_type
  num_cache_nodes      = each.value.num_cache_nodes
  parameter_group_name = each.value.parameter_group_name
  engine_version       = each.value.engine_version
  port                 = each.value.port

  subnet_group_name = aws_elasticache_subnet_group.default.name

  tags = merge(
    var.tags,
    {
      Name = "${each.value.name}-cache"
    }
  )
}
