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


## How to install Powershell 7.x on Linux
- https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1



Once Powershell 7.x is installed. Install on host the Azure Powershell Cmdlet to access resources online:
```powershell
Install-Module -Name Az -Repository PSGallery -Force
```

connect-azaccount -usedeviceauthentication



## How to use
- Download the script
- Define the credentials of the Sharepoint online site in the script
- Register the app in Azure AD and give the app the following permissions:

## How to run
- Run the script from a powershell prompt
- The script will download all files from the root of the Sharepoint site and all files from all subfolders

