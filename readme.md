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


# Grant user-assigned identity access to the key vault
az keyvault set-policy \
    --name mykeyvault \
    --resource-group myResourceGroup \
    --object-id $SP_ID \
<<<<<<< HEAD
    --secret-permissions get 
- Sharepoint online site with files to download
=======
    --secret-permissions get- Sharepoint online site with files to download
>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7
- Define the credentials of the Sharepoint online site in the script
- Register the app in Azure AD and give

- create a local directory called "/data/" for temporary storage of files and structure if needed


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

<<<<<<< HEAD
=======
#Create a Keyvault in Azure and store the following secrets if doesn't exist:
```bash
resourceGroupName="SharepointPS"
managedIdentityName="myACIId"
az identity create \
  --resource-group $resourceGroupName \
  --name $managedIdentityName
```

>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7
# Get Service Principal Id for Managed Identity
```bash
# Get service principal ID of the user-assigned identity
SP_ID=$(az identity show \
  --resource-group $resourceGroupName \
  --name $managedIdentityName \
  --query principalId --output tsv)
<<<<<<< HEAD
=======

# Get resource ID of the user-assigned identity
RESOURCE_ID=$(az identity show \
  --resource-group $resourceGroupName \
  --name $managedIdentityName \
  --query id --output tsv)
```bash

echo $RESOURCE_ID
/subscriptions/45281fc4-c2b7-4b8c-b6d8-38887ee8a127/resourcegroups/SharepointPS/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myACIId

echo $SP_ID
d1823200-5af1-4396-97bb-9e73c0882a8c

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


>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7

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



# Create a Keyvault and store the following secrets in the Keyvault
Will be used to store the following parameters as a user <user>:
- ClientId 
- CertificateBase64Encoded
CLI Code
# Connect to Azure and in order to create a Keyvault. Also connect on host to allow for keyvault access and file transfer to Azure file container

<<<<<<< HEAD
=======
Other authentication models are optional. For example, you can use a service principal or managed identity. For more information, see [Authenticate with the Azure PowerShell cmdlets](https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-5.4.0).

# Create a User-Assigned Managed Identity
CLI Code

>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7

```powershell
# If using a remote host with a browser, use the following command to connect to Azure
New-AzResourceGroup -Name SharepointPS -Location EastUS

Set-AzKeyVaultAccessPolicy -VaultName "SharepointPS-kv" -UserPrincipalName "<user>" -PermissionsToSecrets get,set,delete,list
```

<<<<<<< HEAD
=======
# Create a Managed Identity for the Azure Container Instance
See: https://docs.microsoft.com/en-us/azure/container-instances/container-instances-managed-identity

```powershell

```powershell
>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7

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
```

Az cli:
containerName="usps-pscontainer"
resourceGroupName="SharepointPS"

<<<<<<< HEAD
=======
#CLI to create a Linux Container
az container create --resource-group $resourceGroupName --name $containerName --image mcr.microsoft.com/azure-powershell  --ports 80 --restart-policy Never --command-line "tail -f /dev/null" \
--assign-identity $RESOURCE_ID 

echo $RESOURCE_ID
RESOURCE_ID="/subscriptions/45281fc4-c2b7-4b8c-b6d8-38887ee8a127/resourcegroups/SharepointPS/providers/Microsoft.ManagedIdentity/userAssignedIdentities/"

>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7
az container show \
  --resource-group $resourceGroupName \
  --name $containerName


In the Azure Portal:
- Container Instances
- Select the container
- Select Containers
- Connect
- Select Bash

<<<<<<< HEAD
=======
bash: az login --identity -u
clientId="488bbfd3-9e3d-4764-ab09-f267fc047866"

Connect-AzAccount -Identity

>>>>>>> d0f05778998d8a39130b11230810d0645ca065b7

```bash
apt update
apt upgrade
pwsh
Install-Module PnP.PowerShell -Scope CurrentUser
InstalGl-Module -Name Az -Repository PSGallery -Force
Connect-AzAccount -Identity
GetSPOFile5.ps1

```