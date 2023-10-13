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

TBD:
connect-azaccount -usedeviceauthentication

Download azcopy to upload files to files from Linux to Azure file container:

- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10

For example:
```bash
wget https://aka.ms/downloadazcopy-v10-linux
tar -xvf downloadazcopy-v10-linux
# Move azcopy to current folder
mv azcopy_linux_amd64_10.21.0/azcopy .

```'

Create a Keyvault in Azure and store the following secrets if doesn't exist:

Will be used to store the following parameters:

ClientId 
CertificateBase64Encoded


connect-azaccount -usedeviceauthentication
New-AzResourceGroup -Name SharepointPS -Location EastUS
New-AzKeyVault -Name "SharepointPS-kv" -ResourceGroupName "SharepointPS" -Location "EastUS"

Set-AzKeyVaultAccessPolicy -VaultName "SharepointPS-kv" -UserPrincipalName "mdeleo@mdeleo.onmicrosoft.com" -PermissionsToSecrets get,set,delete,list


``$secretvalue = ConvertTo-SecureString "<secret>" -AsPlainText -Force

$secret = Set-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "ClientID" -SecretValue $secretvalue
$secret = " "
$secret = Get-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "ClientID" -AsPlainText
$secret


$secretvalue = ConvertTo-SecureString "<secret>" -AsPlainText -Force

$secret = Set-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "CertificateBase64Encoded" -SecretValue $secretvalue
$secret = " "
$secret = Get-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "CertificateBase64Encoded" -AsPlainText
$secret
``

# Storage Account creation and configuration

$resourceGroupName = "SharepointPS"
$storageAccountName = "sharepointstoragearc"
$region = "EastUS"

$storageAcct = New-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $region `
    -Kind StorageV2 `
    -SkuName Standard_LRS `
    -EnableLargeFileShare
#Get-AzStorageAccount -ResourceGroupName "RG01" -Name "mystorageaccount"
$storageAcct = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName

$shareName = "archivefileshare"

New-AzRmStorageShare `
    -StorageAccount $storageAcct `
    -Name $shareName `
    -EnabledProtocol SMB `
    -QuotaGiB 20024 | Out-Null

# Create a Directory
New-AzStorageDirectory `
   -Context $storageAcct.Context `
   -ShareName $shareName `
   -Path "data"



Create a file share in Azure storage account:

# this expression will put the current date and time into a new file on your scratch drive
cd "/data"
#Get-Date | Out-File -FilePath "SampleUpload.txt" -Force

# this expression will upload that newly created file to your Azure file share
Set-AzStorageFileContent `
   -Context $storageAcct.Context `
   -ShareName $shareName `
   -Source "/data/sites/aaronbadev/SPOFiles/AaronTestAzure/DownloadAndWriteToBlob.sln" `
   -Path "/data/sites/aaronbadev/SPOFiles/AaronTestAzure/DownloadAndWriteToBlob.sln"




## How to use
- Download the script
- Define the credentials of the Sharepoint online site in the script
- Register the app in Azure AD and give the app the following permissions:

## How to run
- Run the script from a powershell prompt
- The script will download all files from the root of the Sharepoint site and all files from all subfolders

