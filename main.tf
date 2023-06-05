data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azapi_resource" "clusterVnet" {
  type      = "Microsoft.HybridContainerService/virtualNetworks@2022-09-01-preview"
  name      = var.vnet_name
  parent_id = data.azurerm_resource_group.rg.id
}

resource "azapi_resource" "provisionedCluster" {
  tags = {
    Site        = "${var.site_name}"
    Environment = "${var.environment}"
  }

  identity {
    type = "SystemAssigned"
  }

  body = jsonencode(
    {
      extendedLocation = {
        name = var.customLocation_id
        type = "customLocation"
      }
      properties = {
        aadProfile = {
          adminGroupObjectIDs = var.admin_group_object_IDs
        }
        agentPoolProfiles = [
          {
            cloudProviderProfile = {
              infraNetworkProfile = {}
              infraStorageProfile = {}
            }
            count  = var.default_agent_count
            mode   = "User"
            osType = "Linux"
            vmSize = var.default_agent_VM_size
          },
        ]
        cloudProviderProfile = {
          infraNetworkProfile = {
            vnetSubnetIds = [
              data.azapi_resource.clusterVnet.id,
            ]
          }
          infraStorageProfile = {}
        }
        controlPlane = {
          availabilityZones = []
          cloudProviderProfile = {
            infraNetworkProfile = {}
            infraStorageProfile = {}
          }
          controlPlaneEndpoint = {}
          count                = var.controlplane_count
          linuxProfile = {
            ssh = {}
          }
          mode   = "User"
          osType = "Linux"
          vmSize = var.controlplane_VM_size
        }
        features = {
          arcAgentProfile = {
            agentAutoUpgrade = "Enabled"
            agentVersion     = ""
          }
        }
        httpProxyConfig   = {}
        kubernetesVersion = var.kubernetes_version
        linuxProfile = {
          ssh = {
            publicKeys = [
              {
                keyData = var.public_key
              },
            ]
          }
        }
        networkProfile = {
          loadBalancerProfile = {
            cloudProviderProfile = {
              infraNetworkProfile = {}
              infraStorageProfile = {}
            }
            count = var.loadbalancer_count
            linuxProfile = {
              ssh = {}
            }
            mode   = "User"
            osType = "Linux"
            vmSize = var.loadbalancer_VM_size
          }
          loadBalancerSku = var.loadbalancer_sku
          networkPolicy   = var.network_policy
          podCidr         = var.pod_cidr
        }
        windowsProfile = {}
      }
    }
  )
  ignore_casing             = false
  ignore_missing_property   = true
  location                  = data.azurerm_resource_group.rg.location
  name                      = var.cluster_name
  parent_id                 = data.azurerm_resource_group.rg.id
  removing_special_chars    = false
  schema_validation_enabled = true
  type                      = "Microsoft.HybridContainerService/provisionedClusters@2022-09-01-preview"

}
