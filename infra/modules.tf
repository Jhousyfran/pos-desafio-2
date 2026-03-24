module "network" {
  source     = "./modules/network"
  prefix     = var.prefix
  project    = var.project
  cidr_block = var.cidr_block
  tags       = local.tags
}

module "eks_cluster" {
  source  = "./modules/cluster"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  public_subnet_1a_id = module.network.eks_subnet_public_1a_id
  public_subnet_1b_id = module.network.eks_subnet_public_1b_id

}

module "managed_node_group" {
  source  = "./modules/managed-node-group"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  eks_cluster_name     = module.eks_cluster.eks_cluster_name
  private_subnet_1a_id = module.network.eks_subnet_private_1a_id
  private_subnet_1b_id = module.network.eks_subnet_private_1b_id
}

module "eks_loadbalancer_controller" {
  source           = "./modules/aws-loadbalacer-controller"
  prefix           = var.prefix
  project          = var.project
  tags             = local.tags
  oidc             = module.eks_cluster.oidc
  eks_cluster_name = module.eks_cluster.eks_cluster_name

}

module "ecr_repositories" {
  source  = "./modules/ecr"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  repos = [
    "auth-service",
    "flag-service",
    "targeting-service",
    "evaluation-service",
    "analytics-service"
  ]

}

module "databases" {
  source  = "./modules/rds"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  subnet_ids = [module.network.eks_subnet_private_1a_id, module.network.eks_subnet_private_1b_id]
  dbs_config = [
    {
      name           = "auth"
      engine         = "postgres"
      version        = "17.2"
      storage        = 10
      instance_class = "db.t3.micro"
      username       = "appuser"
    },
    {
      name           = "flag"
      engine         = "postgres"
      version        = "17.2"
      storage        = 20
      instance_class = "db.t3.micro"
      username       = "appuser"
    },

    {
      name           = "targeting"
      engine         = "postgres"
      version        = "17.2"
      storage        = 20
      instance_class = "db.t3.micro"
      username       = "appuser"
    }
  ]
}

module "elasticache" {
  source  = "./modules/elasticache"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  subnet_ids = [module.network.eks_subnet_private_1a_id, module.network.eks_subnet_private_1b_id]
  cache_config = [
    {
      name                 = "redis-cache"
      engine               = "redis"
      engine_version       = "6.x"
      node_type            = "cache.t3.micro"
      num_cache_nodes      = 1
      parameter_group_name = "default.redis6.x"
      port                 = 6379
    }
  ]
}

module "dynamodb" {
  source  = "./modules/dynamodb"
  prefix  = var.prefix
  project = var.project
  tags    = local.tags

  dynamodb_table = {
    name           = "ToggleMasterAnalytics"
    billing_mode   = "PROVISIONED"
    read_capacity  = 20
    write_capacity = 20
    attribute_definitions = [
      {
        name = "event_id"
        type = "S"
      }
    ]
  }
}
