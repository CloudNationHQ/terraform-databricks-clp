module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "dbw" {
  source  = "cloudnationhq/dbw/azure"
  version = "~> 1.0"

  workspace = {
    name           = module.naming.databricks_workspace.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku            = "premium"
  }
}


module "cluster_policy" {
  source  = "cloudnationhq/clp/databricks"
  version = "~> 1.0"

  policy = {
    name                  = "${module.naming.databricks_cluster_policy.name} Power User Compute"
    description           = "Policy for power users"
    max_clusters_per_user = 10

    policy_family_name = "Power User Compute"

    policy_family_definition_overrides = {
      autotermination_minutes = {
        type   = "fixed"
        value  = 30
        hidden = true
      }
      "custom_tags.Team" = {
        type  = "fixed"
        value = "Data Engineering"
      }
    }
  }

  depends_on = [module.dbw]
}

module "cluster" {
  source  = "cloudnationhq/cl/databricks"
  version = "~> 1.0"

  cluster = {
    name                    = module.naming.databricks_cluster.name
    policy_id               = module.cluster_policy.policy.id
    autotermination_minutes = 30

    autoscale = {
      min_workers = 1
      max_workers = 5
    }

    apply_policy_default_values = true
  }
  depends_on = [module.dbw]
}
