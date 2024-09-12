# Default
This example highlights the creation of a cluster policy with a custom definition.

## Types

```hcl
policy = object({
  name       = string
  definition = object({
    dbus_per_hour = optional(object({
      type          = "range"
      maxValue      = optional(number)
      minValue      = optional(number)
      defaultValue  = optional(string | number | bool)
      isOptional    = optional(bool)
    }))
    autotermination_minutes  = optional(object({
      type    = "fixed"
      value   = number
      hidden  = optional(bool)
    }))
    node_type_id  = optional(object({
      type    = "fixed"
      value   = string
      hidden  = optional(bool)
    }))
    custom_tags.<tag-name> = optional(object({
      type          = "unlimited"
      default_value = string | number | bool
      isOptional    = optional(bool)
    }))
    spark_version = optional(object({
      type         = "allowlist"
      values       = list(string | number | bool)
      defaultValue = optional(string | number | bool)
      isOptional   = optional(bool)
    }))
  })
  permissions = optional(map(object({
        group_name              = optional(string)
        user_name               = optional(string)
        service_principal_name  = optional(string)
        permission_level        = string
  })))
})
```

## Notes
A different 'type' can be set per policy attribute, these are: "fixed", "forbidden", "allowlist", "blocklist", "regex", "range" and "unlimited".
See for all the policy definition attributes and policy types: https://docs.databricks.com/en/admin/clusters/policy-definition.html

This Databricks cluster policy module has only been tested with a Databricks workspace on Azure cloud, other cloud providers have not been tested yet.