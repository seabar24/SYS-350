# Script for creating linked clone
cls
$LinkedCloneName = Read-Host -Prompt "Enter the name of your Linked Clone VM"
$Snapshot = Read-Host -Prompt "Enter the name for your base VM's Snapshot"
cls

# Stops base VM
Write-Host "Shutting Down Base VM..."
Sleep 3
Stop-VM -Name Windows11-Super1 -Force
Write-Host "Done!"
cls

# Creates snapshot for base VM
Write-Host "Creating Snapshot..."
Sleep 3
Checkpoint-VM -Name Windows11-Super1 -SnapshotName 
Write-Host "Done!"
cls

# Creates Linked Clone
Write-Host "Creating Linked Clone, wait a few moments..."
Sleep 5
New-VM -Name $LinkedCloneName -Path C:\ProgramData\Microsoft\Windows\Hyper-V\ -VHDPath C:\Users\Public\Documents\Hyper-V\Virtual_hard_disks\winchild11.vhdx -Generation 2 -SwitchName "HyperV-WAN"
Write-Host "Done! VM: $LinkedCloneName will start in a few moments..."
Sleep 3
Start-VM -Name $LinkedCloneName
cls
Write-Host "$LinkedCloneName is running."
Write-Host " "