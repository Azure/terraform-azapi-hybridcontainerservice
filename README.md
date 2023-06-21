***Note: This project is in preview stage, the API might change 
***
This Terraform module deploys a Hybrid Kubernetescluster on ASZ using Hybrid Container Service and add support for adding node pool
## Usage in Terraform 1.2.0

***Note: Currently, ARB(Arc Resource Bridge) creation and vnet create can't be provisioned by portal, so we assume customer has a resource group, in the resource group it has pre-provisioned ARB and vnet. This module only create hybrid aks with exsiting ARB and vnet.***


Please view folders in `examples`.

There're some examples in the examples folder. You can execute `terraform apply` command in `examples`'s sub folder to try the module. These examples are tested against every PR with the [E2E Test](#Pre-Commit--Pr-Check--Test).

## Pre-Commit & Pr-Check & Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We assumed that you have setup service principal's credentials in your environment variables like below:

```shell
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

On Windows Powershell:

```shell
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_ID="<service_principal_appid>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

We provide a docker image to run the pre-commit checks and tests for you: `mcr.microsoft.com/azterraform:latest`

To run the pre-commit task, we can run the following command:

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

In pre-commit task, we will:

1. Run `terraform fmt -recursive` command for your Terraform code.
2. Run `terrafmt fmt -f` command for markdown files and go code files to ensure that the Terraform code embedded in these files are well formatted.
3. Run `go mod tidy` and `go mod vendor` for test folder to ensure that all the dependencies have been synced.
4. Run `gofmt` for all go code files.
5. Run `gofumpt` for all go code files.
6. Run `terraform-docs` on `README.md` file, then run `markdown-table-formatter` to format markdown tables in `README.md`.

Then we can run the pr-check task to check whether our code meets our pipeline's requirement(We strongly recommend you run the following command before you commit):

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

To run the e2e-test, we can run the following command:

```text
docker run --rm -v $(pwd):/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:

```text
docker run --rm -v ${pwd}:/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

To follow [**Ensure AKS uses disk encryption set**](https://docs.bridgecrew.io/docs/ensure-that-aks-uses-disk-encryption-set) policy we've used `azurerm_key_vault` in example codes, and to follow [**Key vault does not allow firewall rules settings**](https://docs.bridgecrew.io/docs/ensure-that-key-vault-allows-firewall-rules-settings) we've limited the ip cidr on it's `network_acls`. On default we'll use the ip return by `https://api.ipify.org?format=json` api as your public ip, but in case you need use other cidr, you can assign on by passing an environment variable:

```text
docker run --rm -v $(pwd):/src -w /src -e TF_VAR_key_vault_firewall_bypass_ip_cidr="<your_cidr>" -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:
```text
docker run --rm -v ${pwd}:/src -w /src -e TF_VAR_key_vault_firewall_bypass_ip_cidr="<your_cidr>" -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

## License

[MIT](LICENSE)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

## Document generation

```
terraform-docs markdown table --output-file README.md --output-mode insert  --sort-by required .
```
## Module Spec

The following sections are generated by [terraform-docs](https://github.com/terraform-docs/terraform-docs) and [markdown-table-formatter](https://github.com/nvuillam/markdown-table-formatter), please **DO NOT MODIFY THEM MANUALLY!**

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.provisionedCluster](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.clusterVnet](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Required) The name of cluster | `string` | n/a | yes |
| <a name="input_customLocation_id"></a> [customLocation\_id](#input\_customLocation\_id) | (Required) The name of the customer location that the resources for consul will run in | `string` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | (Required) Base64 encoded public certificate used by the agent to do the initial handshake to the backend services in Azure. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group that the resources for consul will run in | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | (Required) The name of the vnet that the resources for consul will run in | `string` | n/a | yes |
| <a name="input_admin_group_object_IDs"></a> [admin\_group\_object\_IDs](#input\_admin\_group\_object\_IDs) | (Optional) If you want to Use Azure AD for authentication and Kubernetes native RBAC for authorization, specify AAD group here. Assign Azure Active Directory groups that will have admin access within the cluster. Make sure you are part of the assigned groups to ensure cluster access after deployment regardless of if you are an Owner or a Contributor. | `list(string)` | `[]` | no |
| <a name="input_controlplane_VM_size"></a> [controlplane\_VM\_size](#input\_controlplane\_VM\_size) | (Optional) VM sku of the control plane | `string` | `"Standard_A4_v2"` | no |
| <a name="input_controlplane_count"></a> [controlplane\_count](#input\_controlplane\_count) | (Optional) VM count of the control plane | `number` | `1` | no |
| <a name="input_default_agent_VM_size"></a> [default\_agent\_VM\_size](#input\_default\_agent\_VM\_size) | (Optional) VM sku of the default node pool | `string` | `"Standard_A4_v2"` | no |
| <a name="input_default_agent_count"></a> [default\_agent\_count](#input\_default\_agent\_count) | (Optional) VM count of the default node pool | `number` | `1` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the site, possiblily value like: test/prod | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Optional) kubernates version of this hybrid aks | `string` | `"v1.22.11"` | no |
| <a name="input_loadbalancer_VM_size"></a> [loadbalancer\_VM\_size](#input\_loadbalancer\_VM\_size) | (Optional) VM sku of the load balancer | `string` | `"Standard_K8S3_v1"` | no |
| <a name="input_loadbalancer_count"></a> [loadbalancer\_count](#input\_loadbalancer\_count) | (Optional) VM count of the load balancer | `number` | `1` | no |
| <a name="input_loadbalancer_sku"></a> [loadbalancer\_sku](#input\_loadbalancer\_sku) | (Optional) value | `string` | `"unstacked-haproxy"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | (Optional) network cni of this hybrid aks | `string` | `"calico"` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | (Optional) CIDR of pods in this hybrid aks | `string` | `"10.245.0.0/16"` | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | (Optional) The name of the site | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | the id of created hybrid aks |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | the id of the resource group |
<!-- END_TF_DOCS -->