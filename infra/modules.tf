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
