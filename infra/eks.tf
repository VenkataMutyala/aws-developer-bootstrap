locals {
    cidr_block = "10.64.0.0/16"
    namespace = "eg"
    stage = "test"
    name = "app"
    delimiter = "-"
    tags = { "environment" = "test" }
}

module "vpc" {
  source = "cloudposse/vpc/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  namespace  = local.namespace
  stage      = local.stage
  name       = local.name
  cidr_block = local.cidr_block
}

  module "label" {
    source = "cloudposse/label/null"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
    namespace  = local.namespace
    stage      = local.stage
    name       = local.name
    delimiter  = local.delimiter
    tags       = local.tags
  }


  module "subnets" {
    source = "cloudposse/dynamic-subnets/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"

    availability_zones   = ["us-west-2a","us-west-2b"]
    vpc_id               = module.vpc.vpc_id
    igw_id               = module.vpc.igw_id
    cidr_block           = module.vpc.vpc_cidr_block
    nat_gateway_enabled  = false
    nat_instance_enabled = false

    tags    = local.tags
    context = module.label.context
  }

  # module "eks_node_group" {
  #   source = "cloudposse/eks-node-group/aws"
  #   # Cloud Posse recommends pinning every module to a specific version
  #   # version     = "x.x.x"

  #   instance_types                     = [var.instance_type]
  #   subnet_ids                         = module.subnets.public_subnet_ids
  #   health_check_type                  = var.health_check_type
  #   min_size                           = var.min_size
  #   max_size                           = var.max_size
  #   cluster_name                       = module.eks_cluster.eks_cluster_id

  #   # Enable the Kubernetes cluster auto-scaler to find the auto-scaling group
  #   cluster_autoscaler_enabled = var.autoscaling_policies_enabled

  #   context = module.label.context

  #   # Ensure the cluster is fully created before trying to add the node group
  #   module_depends_on = module.eks_cluster.kubernetes_config_map_id
  # }

  module "eks_cluster" {
    source = "cloudposse/eks-cluster/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"

    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.subnets.public_subnet_ids

    oidc_provider_enabled = true

    context = module.label.context
    region = "us-west-2"
    kubernetes_version = "1.21"
  }