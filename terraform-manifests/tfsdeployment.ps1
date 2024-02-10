#disable windows defenders Firewall 

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled false 
Start-Sleep -Seconds 20

#creating local user "K-TFS001RMAgent"
$Username = "K-TFS001RMAgent"
$Password = "t0GO^A02^c"

$group = "Administrators"
$group1 = "Remote Desktop Users"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

    Write-Host "Adding local user $Username to $group1."
    & NET LOCALGROUP $group1 $Username /add

}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE
Start-Sleep -Seconds 30

#Add domain authentication Credentials

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Start-Sleep -Seconds 120

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Start-Sleep -Seconds 120

Install-Module -Name CredentialManager
Start-Sleep -Seconds 60

New-StoredCredential -Target k-tfsbuild001.tmalan.co.uk -UserName TMA\K-TFS001RMAgent -Password "t0GO^A02^c" -Type Generic -Persist LocalMachine