#Unconstrained Delegation


Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Get all the servers in Azure AD
$servers = Get-AzureADServicePrincipal

# Initialize an array to store the servers with unconstrained delegation
$unconstrainedDelegationServers = @()

# Loop through each server and check if it is configured with unconstrained delegation
foreach ($server in $servers) {
  $delegatedOrgs = Get-AzureADServicePrincipalOAuth2PermissionGrant -ObjectId $server.ObjectId
  if ($delegatedOrgs.Count -gt 0 -and $delegatedOrgs[0].ConsentType -eq "AllPrincipals") {
    $unconstrainedDelegationServers += $server
  }
}

# Display the list of servers with unconstrained delegation
Write-Output "Servers with Unconstrained Delegation:"
foreach ($server in $unconstrainedDelegationServers) {
  Write-Output $server.DisplayName
}

# Export the list to a CSV file
$unconstrainedDelegationServers | Select-Object DisplayName | Export-Csv -Path "c:\temp\UnconstrainedDelegationServers.csv"
