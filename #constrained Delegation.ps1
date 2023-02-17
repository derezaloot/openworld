Import-Module AzureAD

# Connect to Azure AD
#Connect-AzureAD

# Get the list of servers from Azure AD
$servers = Get-AzureADDevice

# Initialize an empty array to store the secure delegation status of each server
$secureDelegationStatus = @()

# Loop through each server
foreach ($server in $servers) {
    # Check if the server is configured with secure delegation
    if ($server.TrustType -eq "Secure") {
        # Add the server name and its secure delegation status to the array
        $secureDelegationStatus += [pscustomobject]@{
            ServerName = $server.DisplayName
            SecureDelegation = "Configured"
        }
    } else {
        # Add the server name and its secure delegation status to the array
        $secureDelegationStatus += [pscustomobject]@{
            ServerName = $server.DisplayName
            SecureDelegation = "Not Configured"
        }
    }
}

# Display the list of servers and their secure delegation status
$secureDelegationStatus

# Export the list of servers and their secure delegation status to a CSV file
$secureDelegationStatus | Export-Csv -Path "c:\temp\SecureDelegationStatus.csv" -NoTypeInformation

# Auto-scale the rows in the CSV file
$Excel = New-Object -ComObject Excel.Application
$Workbook = $Excel.Workbooks.Open("c:\temp\SecureDelegationStatus.csv")
$Worksheet = $Workbook.Sheets.Item(1)
$Worksheet.Cells.EntireColumn.AutoFit()
$Workbook.Save()
$Excel.Quit()
