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
- Register the app in Azure AD and give

- create a local directory called "/data/" for temporary storage of files and structure if needed


## How to install Powershell 7.x on Linux
- https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1



Once Powershell 7.x is installed. Install on host the Azure Powershell Cmdlet to access resources online:
```powershell
Install-Module -Name Az -Repository PSGallery -Force
```

Download azcopy to upload files to files from Linux to Azure file container:

- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10

For example:
```bash
wget https://aka.ms/downloadazcopy-v10-linux
tar -xvf downloadazcopy-v10-linux
# Move azcopy to current folder
mv azcopy_linux_amd64_10.21.0/azcopy .
```

Create a Keyvault in Azure and store the following secrets if doesn't exist:

Will be used to store the following parameters:
- ClientId 
- CertificateBase64Encoded

# Connect to Azure and in order to create a Keyvault. Also connect on host to allow for keyvault access and file transfer to Azure file container

Other authentication models are optional. For example, you can use a service principal or managed identity. For more information, see [Authenticate with the Azure PowerShell cmdlets](https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-5.4.0).


```powershell
# If using a remote host with a browser, use the following command to connect to Azure
connect-azaccount -usedeviceauthentication
New-AzResourceGroup -Name SharepointPS -Location EastUS
New-AzKeyVault -Name "SharepointPS-kv" -ResourceGroupName "SharepointPS" -Location "EastUS"

Set-AzKeyVaultAccessPolicy -VaultName "SharepointPS-kv" -UserPrincipalName "mdeleo@mdeleo.onmicrosoft.com" -PermissionsToSecrets get,set,delete,list
```

# Store the following secrets in the Keyvault
- ClientId
- CertificateBase64Encoded

```powershell
$secretvalue = ConvertTo-SecureString "<secret>" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "ClientID" -SecretValue $secretvalue

$secretvalue = ConvertTo-SecureString "<secret>" -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "CertificateBase64Encoded" -SecretValue $secretvalue
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

