# Databricks Cluster Policy

This Terraform module allows for the creation and management of a Databricks cluster policy with support for setting permissions and looking up driver node types and runtime spark versions. It integrates with Terratest to ensure the robustness and reliability of your infrastructure.

## Features

- provision Databricks cluster policies with ease using Terraform
- utilization of Terratest for robust validation
- set permissions for a Databricks cluster policy
- support for custom policy definition
- support for family policy with overrides

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.51 |
| <a name="requirement_databricks_workspace"></a> [databricks workspace](#requirement\_databricks_workspace) | ~> n/a |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | ~> 1.51 |

## Resources

| Name | Type |
| :-- | :-- |
| [databricks_cluster_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_cluster_policy](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/cluster_policy) | data source |
| [databricks_permissions](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |


## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `policy` | describes databricks cluster related configuration | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `policy` | contains the databricks cluster details |
| `policy_permissions` | contains the databricks cluster permissions details |

## Testing

As a prerequirement, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) includes two distinct variations of tests. The first one is designed to deploy different usage scenarios of the module. These tests are executed by specifying the TF_PATH environment variable, which determines the different usages located in the example directory.

To execute this test, input the command ```make test TF_PATH=default```, substituting default with the specific usage you wish to test.

The second variation is known as a extended test. This one performs additional checks and can be executed without specifying any parameters, using the command ```make test_extended```.

Both are designed to be executed locally and are also integrated into the github workflow.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

This Databricks cluster policy module has only been tested on Azure cloud, other cloud providers (AWS or GCP) have not been tested (yet). Therefore, in the examples a Databricks workspace host url is retrieved from the AzureRM provider and set to the Databricks provider.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-databricks-clp/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/databricks)
- [Policy Definition]( https://docs.databricks.com/en/admin/clusters/policy-definition.html)
- [Rest Api](https://docs.databricks.com/api/azure/workspace/clusterpolicies)
