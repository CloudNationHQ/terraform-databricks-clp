data "databricks_cluster_policy" "policy" {
  for_each = try(var.policy.policy_family_name, {}) != {} ? { "family" = var.policy.policy_family_name } : {}

  name = var.policy.policy_family_name
}

resource "databricks_cluster_policy" "policy" {
  name                  = var.policy.name
  description           = try(var.policy.description, null)
  definition            = try(jsonencode(var.policy.definition), null)
  max_clusters_per_user = try(var.policy.max_clusters_per_user, null)

  policy_family_id                   = try(var.policy.policy_family_id, data.databricks_cluster_policy.policy["family"].policy_family_id, null)
  policy_family_definition_overrides = try(jsonencode(var.policy.policy_family_definition_overrides), null)
}

resource "databricks_permissions" "policy_permissions" {
  for_each = try(var.policy.permissions, {}) != {} ? { "default" = var.policy.permissions } : {}

  cluster_policy_id = databricks_cluster_policy.policy.id

  dynamic "access_control" {
    for_each = {
      for key, ac in each.value : key => ac
    }
    content {
      group_name             = try(access_control.value.group_name, null)
      user_name              = try(access_control.value.user_name, null)
      service_principal_name = try(access_control.value.service_principal_name, null)
      permission_level       = access_control.value.permission_level
    }
  }
}

