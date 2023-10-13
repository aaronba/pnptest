# FILEPATH: GetSPOFile.ps1

param (
     [string]$SiteUrl,
     [string]$ClientId,
     [string]$Tenant,
     [string]$CertificateBase64Encoded,
     [string]$LibraryName = "SPOFiles",
     [string]$DataDirectory = "~/data"
)

# Parameters for script 
# Sharepoint Site information
$SiteUrl = 'https://aaronbadev.sharepoint.com/sites/aaronbadev'
$Tenant = "aaronbadev.onmicrosoft.com"
$LibraryName = "SPOFiles"
#
# From Key Vault the ClientID and CertificateBase64Encoded are retrieved as secrets
$ClientID = Get-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "ClientID" -AsPlainText
#$ClientID
$CertificateBase64Encoded = Get-AzKeyVaultSecret -VaultName "SharepointPS-kv" -Name "CertificateBase64Encoded" -AsPlainText
#$CertificateBase64Encoded

# Local directory to download files to
$DataDirectory = "/data"

# Prerequisite for script out 
mkdir $DataDirectory
mkdir $DataDirectory/scripts
# FILEPATH: GetSPOFile.ps1

# Connect to SharePoint Online
Connect-PnPOnline -Url $SiteUrl -ClientId $ClientId -Tenant $Tenant -CertificateBase64Encoded $CertificateBase64Encoded

# Get the library
$library = Get-PnPList -Identity $LibraryName

# Get all items in the library
$items = Get-PnPListItem -List $library

# Create an array to store the file and folder names
$filePaths = @()

# Loop through each item in the library
foreach ($item in $items) 
{
       # Get the file reference and file type
       $fileRef = $item.FieldValues.FileRef
       $File_x0020_Type = $item.FieldValues.File_x0020_Type

       # Determine if the item is a file or folder and add the path to the array
       if ($null -eq $File_x0020_Type) 
       {
             #Write-Host "Folder: $fileRef"
       } 
      else 
       {
             # Get the filename and directory path
            $filename = Split-Path -Leaf $fileRef
            $directory = Split-Path $fileRef -Parent

            # Create a temporary folder path and add the file path to the array
            $tempFolderPath = "$DataDirectory$directory"
            $tempFilePath = "$tempFolderPath/$filename"

            if (!(Test-Path $tempFilePath)) 
            {
                 #Write-Host "File not present at $tempFilePath"
                 $fileStatus = "Not Downloaded"  
                 $fileSize = 0
            }
            else 
            {
                 #Write-Host "File already exists at $tempFilePath"
                 $fileStatus = "Downloaded"
                 $fileSize = (Get-Item $tempFilePath).Length
            }

            $filePaths += @{
                  SPOPath = $fileRef
                  LocalPath = $tempFilePath
                  Status = $fileStatus
                  FileSize = $fileSize
            }
       }
}

# Output the file paths prior to the download
$output = "***************************************************`r`n"
$output += "* File Download Status (Before Download)`r`n"
$output += "* $(Get-Date)`r`n"
$output += ($filePaths | Select-Object SPOPath, LocalPath, Status, FileSize | Out-String)
$output += "***************************************************`r`n"
$output += "`r`n"

# Write the output to a file
$output | Out-File -FilePath "$DataDirectory/scripts/GetSPOFileOutput.txt" -Encoding UTF8 -Append

Write-Host $output

#Prompt the user to continue
$continue = Read-Host "Do you want to continue with the Download (Y/N)"

# Check if the user wants to continue
if ($continue -eq "Y" -or $continue -eq "y") 
{
     # Download the files
     foreach ($file in $filePaths) 
     {
          if ($file.Status -eq ("Not Downloaded")) 
          {
               # Create the temporary folder if it doesn't exist
               $tempFolderPath = Split-Path $file.LocalPath -Parent
               New-Item -ItemType Directory -Path $tempFolderPath -Force

               # Download the file
               Get-PnPFile -Url $file.SPOPath -Path $tempFolderPath -Filename $file.LocalPath -AsFile -Force

               # Update the file status and size in the array
               $file.Status = "Downloaded"
               $file.FileSize = (Get-Item $file.LocalPath).Length

               # Output the path where the file was downloaded
               Write-Host "File downloaded to $($file.LocalPath)"
          }
          else {
               # Output the path where the file was downloaded
               Write-Host "File already downloaded to $($file.LocalPath)"      
          }
     }

     # Output the file paths after the download
     #Write-Host "***************************************************"
     #Write-Host "* File Download Status (After Download))"
     #Write-Host "* $(Get-Date)"
     #$filePaths | Select-Object SPOPath, LocalPath, Status, FileSize
     #Write-Host "***************************************************"

     $output = "***************************************************`r`n"
     $output += "* File Download Status (Before Download)`r`n"
     $output += "* $(Get-Date)`r`n"
     $output += ($filePaths | Select-Object SPOPath, LocalPath, Status, FileSize | Out-String)
     $output += "***************************************************`r`n"
     $output += "`r`n"

     # Write the output to a file
     $output | Out-File -FilePath "$DataDirectory/scripts/GetSPOFileOutput.txt" -Encoding UTF8 -Append
}
else 
{
    Write-Host "Exiting script"
}


