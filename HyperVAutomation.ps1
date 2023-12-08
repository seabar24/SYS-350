# Script for creating linked clone
cls
$LinkedCloneName = Read-Host -Prompt "Enter the name of your Linked Clone VM"
$Snapshot = Read-Host -Prompt "Enter the name for your base VM's Snapshot"
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

# Functgion to Automate Hyper-V 
function HyperV() {
# Menu to Automate Hyper-V
cls



    switch($choice) {

        "1" {
        # Summary View of VMs w/ IPs, Powerstate, and Name
            }
    
        "2" {
        # Gives detailed information about a given VM. OS, , , , 
            }

        "3" {
        # PowerOn VM
            cls
            $VMName = Read-Host -Prompt "Enter the name of a VM you want to Power Off"
            cls
            Write-Host "Powering on $VMName..."
            Sleep 3
            Start-VM -Name $VMName
            Write-Host "Done!"
            cls
            HyperV
            }

        "4" {
        # PowerOff VM
            cls
            $VMName = Read-Host -Prompt "Enter the name of a VM you want to Power Off"
            cls
            Write-Host "Shutting Down $VMName..."
            Sleep 3
            Stop-VM -Name $VMName -Force
            Write-Host "Done!"
            cls
            HyperV
            }

        "5" {
        # Snapshot VMs
            }

        "6" {
        # Create a Linked Clone of a VM
            cls
            $LinkedCloneName = Read-Host -Prompt "Enter the name of your Linked Clone VM"
            $VMPath = Read-Host -Prompt "Enter the path you wish to store your VM"
            $VHDPath = Read-Host -Prompt "Enter the name"

            Write-Host "Creating Linked Clone, wait a few moments..."
            Sleep 5
            New-VM -Name $LinkedCloneName -Path C:\ProgramData\Microsoft\Windows\Hyper-V\ -VHDPath C:\Users\Public\Documents\Hyper-V\Virtual_hard_disks\winchild11.vhdx -Generation 2 -SwitchName "HyperV-WAN"
            Write-Host "Done! VM: $LinkedCloneName will start in a few moments..."
            Sleep 3
            Start-VM -Name $LinkedCloneName
            cls
            Write-Host "$LinkedCloneName is running."
            Write-Host " "
            HyperV
            }

        "7" {
        # Change the Network a VM is on
            }

        "8" {
        #Delete a VM from Disk
            }

        else {
        # If Options 1-8 are not selected
            Write-Host -BackgroundColor red -ForegroundColor white "WRONG WRONG WRONG. `n NUH NUH NUH."
            sleep 3
            HyperV
             }

    }
}
HyperV