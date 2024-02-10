# Import the modules
Import-module 'az.accounts'
Import-module 'az.compute'

<# Connection example for run as account
$connectionName = "AzureRunAsConnection"
$servicePrincipalConnection = Get-AutomationConnection -name $connectionName
Connect-AzureRmAccount -ServicePrincipal -TenantId $servicePrincipalConnection.TenantId -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
#>

# Connect to Azure with the System Managed Identity
Connect-AzAccount -Identity

# Variables
# Set the tag for the VM's to start and stop and the tag value
# VM's with matching tag and value, in the specified scope will start or stop
$tag = "mw_dev"
$tagVale = "mw_dev"


	# Function to stop the servers
		function Stop-Vms {
    		param (
        		$vms
    		)
    		foreach ($vm in $vms) {
        		try {
            		# Stop the VM
            		$vm | stop-AzVM -ErrorAction Stop -Force -NoWait
        		}
        		catch {
            		$ErrorMessage = $_.Exception.message
            		Write-Error ("Error starting the VM: " + $ErrorMessage)
            		Break
        		}
    		}
		
		}  
		
		# Function to start the servers
		function Start-Vms {
    		param (
        		$vmst
    		)
    		foreach ($vm in $vmst) {
        		try {
            		# Start the VM
            		$vm | start-AzVM -ErrorAction Start -Force -NoWait
        		}
        		catch {
            		$ErrorMessage = $_.Exception.message
            		Write-Error ("Error stopping the VM: " + $ErrorMessage)
            		Break
        		}
    		}
		
		}  
		
		
		# Get the servers
		try {
    		$vms = (get-azvm -ErrorAction Stop | Where-Object { $_.tags[$tag] -eq $tagVale })
		}
		catch {
    		$ErrorMessage = $_.Exception.message
    		Write-Error ("Error returning the VMs: " + $ErrorMessage)
    		Break
		}
# Get the servers
		try {
    		$vmst = (get-azvm -ErrorAction Start | Where-Object { $_.tags[$tag] -eq $tagVale })
		}
		catch {
    		$ErrorMessage = $_.Exception.message
    		Write-Error ("Error returning the VMs: " + $ErrorMessage)
    		Break
		}
		
	if($Action -eq "Stop") 
    { 
        Write-output "Stopping the following servers:"
		Write-output $vms.Name
		stop-vms $vms
    } 
    else 
    { 
        Write-Output "Starting VMs"; 
        Write-output $vms.Name
		start-vms $vms 
    }
