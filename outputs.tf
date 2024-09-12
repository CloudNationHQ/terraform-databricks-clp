output "policy" {
  value = databricks_cluster_policy.policy
}

output "policy_permissions" {
  value = databricks_permissions.policy_permissions
}
