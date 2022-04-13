#requires -version 5.1

#test if VM setup is complete

#The password will be passed by the control script WaitforVM.ps1
#You can manually set it while developing this Pester test
$LabData = Import-PowerShellDataFile -Path $PSScriptRoot\VMConfigurationData.psd1
$Secure = ConvertTo-SecureString -String "$($labdata.allnodes.labpassword)" -AsPlainText -Force
$Domain = "AtdpLab2.Pri"
$cred = New-Object PSCredential "Company\Administrator", $Secure

#The prefix only changes the name of the VM not the guest computername
$prefix = $Labdata.NonNodeData.Lability.EnvironmentPrefix

$all = @()


$all | Remove-PSSession
