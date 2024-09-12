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
    name = "${module.naming.databricks_cluster_policy.name} General Compute"
    definition = {
      dbus_per_hour = {
        type     = "range"
        maxValue = 10
      }
      autotermination_minutes = {
        type   = "fixed"
        value  = 20
        hidden = true
      }
      "custom_tags.Team" = {
        type          = "unlimited"
        default_value = "Sales"
        isOptional    = false
      }
      node_type_id = {
        type  = "fixed"
        value = "Standard_F4s"
      }
      spark_version = {
        type   = "allowlist"
        values = ["auto:latest-lts", "14.1.x-scala2.12"]
      }
    }

    permissions = {
      group1 = {
        group_name       = "users"
        permission_level = "CAN_USE"
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
    num_workers             = 2
    autotermination_minutes = 20
    enable_elastic_disk     = true

    spark_version = {
      latest = true
    }

    node_type = {
      id = "Standard_F4s"
    }

    custom_tags = {
      Team = "Data Engineering"
    }
  }
  depends_on = [module.dbw]
}
