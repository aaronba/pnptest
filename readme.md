# Powershell that downloads files from Sharepoint online to an Azure mounted file container

This powersheill script will download files from Sharepoint online to an Azure mounted file container. The script will download all files from the root of the Sharepoint site and all files from all subfolders. It can be run as a scheduled task to keep up to date as needed. The script will only download files that have been added since the last run.

Written for Powershell 7.x that is supported in Windows, Linux and MacOS.

Need to install on host the Powershell Cmdlet to access Sharepoint online:
```powershell
Install-Module PnP.PowerShell -Scope CurrentUser

```

Reference: https://pnp.github.io/powershell/articles/installation.html


## Prerequisites
- Azure file container mounted on the machine running the script. A subfolder called "script" needs to exist as a file folder
- Sharepoint online site with files to download
- Define the credentials of the Sharepoint online site in the script


## How to install Powershell 7.x on Linux
- Not needed if choosing the Powershell container, already installed vanilla 7.x
- https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1


Once Powershell 7.x is installed. Install on host the Azure Powershell Cmdlet to access resources online:
```powershell
Install-Module -Name Az -Repository PSGallery -Force
```


# Create a Managed Identity for the Azure Container Instance
See: https://docs.microsoft.com/en-us/azure/container-instances/container-instances-managed-identity

CLI CODE for Cloudshell

#Create a User Identity in Azure
```bash
resourceGroupName="SharepointPS"
managedIdentityName="myACIId"
az identity create \
  --resource-group $resourceGroupName \
  --name $managedIdentityName
```

#Create a Keyvault in Azure and store the following secrets if doesn't exist:
```bash
resourceGroupName="SharepointPS"
managedIdentityName="myACIId"
az identity create \
  --resource-group $resourceGroupName \
  --name $managedIdentityName
```

# Get Service Principal Id for Managed Identity
```bash
# Get service principal ID of the user-assigned identity
SP_ID=$(az identity show \
  --resource-group $resourceGroupName \
  --name $managedIdentityName \
  --query principalId --output tsv)

# Get resource ID of the user-assigned identity
RESOURCE_ID=$(az identity show \
  --resource-group $resourceGroupName \
  --name $managedIdentityName \
  --query id --output tsv)
```bash


# Grant user-assigned identity access to the key vault
az keyvault set-policy \
    --name SharepointPS-kv \
    --resource-group $resourceGroupName \
    --object-id $SP_ID \
    --secret-permissions "get,list"


az container create \
  --resource-group myResourceGroup \
  --name mycontainer \
  --image mcr.microsoft.com/azure-cli \
  --assign-identity $RESOURCE_ID \
  --command-line "tail -f /dev/null"


# Get resource ID of the user-assigned identity
RESOURCE_ID=$(az identity show \
  --resource-group $resourceGroupName \
  --name $managedIdentityName \
  --query id --output tsv)
```bash


# Grant user-assigned identity access to the key vault
az keyvault set-policy \
    --name SharepointPS-kv \
    --resource-group $resourceGroupName \
    --object-id $SP_ID \
    --secret-permissions "get"



# Store the following secrets in the Keyvault
- ClientId
- CertificateBase64Encoded

```powershell
$secretvalue = ConvertTo-SecureString "<secret>" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "ClientID" -SecretValue $secretvalue
$secret = Get-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "CertificateBase64Encoded" -AsPlainText
$secret

$secretvalue = ConvertTo-SecureString "<secret>" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "CertificateBase64Encoded" -SecretValue $secretvalue
$secret = Get-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "ClientID" -AsPlainText
$secret
```

# Storage Account creation and configuration

```powershell
$resourceGroupName = "SharepointPS"
$storageAccountName = "sharepointstoragearc"
$region = "EastUS"
$shareName = "archivefileshare"

$storageAcct = New-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $region `
    -Kind StorageV2 `
    -SkuName Standard_LRS `
    -EnableLargeFileShare

New-AzRmStorageShare `
    -StorageAccount $storageAcct `
    -Name $shareName `
    -EnabledProtocol SMB `
    -QuotaGiB 20024 | Out-Null
```

# Create a Top Level Directory
```powershell
$topLevelDir = "data"
New-AzStorageDirectory `
   -Context $storageAcct.Context `
   -ShareName $shareName `
   -Path $topLevelDir | Out-Null
```

## How to use
- Download the script
- Define the credentials of the Sharepoint online site in the script
- Register the app in Azure AD and give the app the following permissions:

## How to run
- Run the script from a powershell prompt
- The script will download all files from the root of the Sharepoint site and all files from all subfolders

## Deploying to an Azure Container Instance

```powershell

#Create resource group
$resourceGroupName = "SharepointPS"
New-AzResourceGroup -Name  $resourceGroupName -Location "EastUS"

#CLI to create a Linux Container
# Resource ID for USer Identity
RESOURCE_ID="/subscriptions/45281fc4-c2b7-4b8c-b6d8-38887ee8a127/resourcegroups/SharepointPS/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myACIId"

containerName="usps-pscontainer"
resourceGroupName="SharepointPS"
az container create --resource-group $resourceGroupName --name $containerName \
 --image mcr.microsoft.com/azure-powershell \
 --restart-policy Never \
 --azure-file-volume-account-name sharepointstoragearc \
 --azure-file-volume-account-key "8WsTm2PxnkJaGfZha6He7UNZP84axvvRoqz1/vKXwWUI10NwFxaX9b9alkg8Qswu2YOYBAYHy94O+AStxQf9/Q==" \
 --azure-file-volume-share-name archivefileshare \
 --azure-file-volume-mount-path /data \
 --assign-identity $RESOURCE_ID \
 --command-line "tail -f /dev/null"

az container show \
  --resource-group $resourceGroupName \
  --name $containerName
```

In the Azure Portal:
- Container Instances
- Select the container
- Select Containers
- Connect
- Select Bash

```bash
apt update
apt upgrade
pwsh
Install-Module PnP.PowerShell -Scope CurrentUser
InstalGl-Module -Name Az -Repository PSGallery -Force
Connect-AzAccount -Identity
GetSPOFile5.ps1
```