#Windows app and user list
Import-Module PSWritePDF.psd1

# Define the path to the file server
$fileServerPath = "C:\temp"

# Get a list of all installed applications
$installedApps = Get-WmiObject Win32_Product | Select-Object Name, Version

# Get a list of all user accounts
$userAccounts = Get-WmiObject Win32_UserAccount | Select-Object Name, Domain, Disabled, SID

# Get a list of modified System COM+ attributes
$comAttributes = Get-WmiObject -Query "SELECT * FROM Win32_COMSetting WHERE SettingID LIKE '%COM+ System Application%'" | Select-Object SettingID, ComponentID, Component, PartComponent

# Create a new object to store all the information
$systemInformation = [PSCustomObject] @{
    "Installed Applications" = $installedApps
    "User Accounts" = $userAccounts
    "Modified System COM+ Attributes" = $comAttributes
}

# Output the information to a PDF file
$fileName = "$($fileServerPath)\SystemInformation_$(Get-Date -Format "yyyy-MM-dd").pdf"
$systemInformation | Export-PDF -Path $fileName
