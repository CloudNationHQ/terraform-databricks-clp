# Policy Family
This example highlights the creation of a cluster policy using an existing policy family and override attributes. 

## Types

```hcl
policy = object({
  name                  = string
  description           = optional(string)
  max_clusters_per_user = optional(number)
  
  ## either family name or id is required if definition is not set
  policy_family_name    = optional(string) 
  policy_family_id      = optional(string)

  policy_family_definition_overrides = optional(object({
      autotermination_minutes  = optional(object({
        type    = "fixed"
        value   = number
        hidden  = optional(bool)
      }))
      custom_tags.<tag-name> = optional(object({
        type    = "fixed"
        value   = string
        hidden  = optional(bool)
    }))
  }))
  })
```

## Notes
In order to lookup the policy_family_id, the policy_family_name property can be passed instead which retrieves the concerning id. 

A different 'type' can be set per policy attribute for the definition overrides, these are: "fixed", "forbidden", "allowlist", "blocklist", "regex", "range" and "unlimited".
See for all the policy definition attributes and policy types: https://docs.databricks.com/en/admin/clusters/policy-definition.html

This Databricks cluster policy module has only been tested with a Databricks workspace on Azure cloud, other cloud providers have not been tested yet.