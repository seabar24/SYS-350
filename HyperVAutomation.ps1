﻿# Script for creating linked clone
#cls
#$LinkedCloneName = Read-Host -Prompt "Enter the name of your Linked Clone VM"
#$Snapshot = Read-Host -Prompt "Enter the name for your base VM's Snapshot"
#cls

# Creates snapshot for base VM
#Write-Host "Creating Snapshot..."
#Sleep 3
#Checkpoint-VM -Name Windows11-Super1 -SnapshotName 
#Write-Host "Done!"
#cls

# Creates Linked Clone
#Write-Host "Creating Linked Clone, wait a few moments..."
#Sleep 5
#New-VM -Name $LinkedCloneName -Path C:\ProgramData\Microsoft\Windows\Hyper-V\ -VHDPath C:\Users\Public\Documents\Hyper-V\Virtual_hard_disks\winchild11.vhdx -Generation 2 -SwitchName "HyperV-WAN"
#Write-Host "Done! VM: $LinkedCloneName will start in a few moments..."
#Sleep 3
#Start-VM -Name $LinkedCloneName
#cls
#Write-Host "$LinkedCloneName is running."
#Write-Host " "

# Function to Automate Hyper-V 
function HyperV() {
# Menu to Automate Hyper-V
cls

Write-Host "Hyper-V Automation Menu"
Write-Host "1. VM Information"
Write-Host "2. Power On"
Write-Host "3. Power Off"
Write-Host "4. Take a Snapshot"
Write-Host "5. Create a Linked Clone"
Write-Host "6. Change VM's Network"
Write-Host "7. Delete a VM from Disk"
$choice = Read-Host -Prompt "`nSelect a choice or 'q' to quit"

function checkVM ($VM) {
    # Checks if VM Exists

    $test = Get-VM -Name $VM -ErrorAction SilentlyContinue

    if ($test -eq $null) {
        cls
        Write-Host "The VM '$VM' doesn't exist!"
        sleep 3
        HyperV
    }
}

    switch($choice) {

        "1" {
        # Summary View of VMs w/ IPs, Powerstate, and Name
            cls
            $vms = Get-VM | Select-Object Name, State
            foreach ($vm in $vms) {
                Write-Host "Name: $($vm.Name)`nPower State: $($vm.State)`n`n"
                }
            $vmchosen = Read-Host -Prompt "Enter the name of a VM you would like more info about"
            checkVM $vmchosen

            $vmInfo = Get-VM -Name $vmchosen
            $memory = $vmInfo.MemoryAssigned
            $processor = $vmInfo.ProcessorCount
            $network = $vmInfo.NetworkAdapters
            $IntServ = $vmInfo.IntegrationServicesVersion
            
            Write-Host "Name = $vmchosen"
            Write-Host "Memory Assigned = $memory"
            Write-Host "Processor Count = $processor"
            Write-Host "Network Adapters = $network"
            Write-Host "Integrated Services = $IntServ"

            Read-Host "Press 'Enter' when you are Done"
            HyperV
            }

        "2" {
        # PowerOn VM
            cls
            $VMName = Read-Host -Prompt "Enter the name of a VM you want to Power On"
            cls
            checkVM $VMName
      
            Write-Host "Powering on $VMName..."
            Sleep 3
            Start-VM -Name $VMName
            Write-Host "Done!"
            Sleep 3
            sleep 3
            cls
            HyperV
            }

        "3" {
        # PowerOff VM
            cls
            $VMName = Read-Host -Prompt "Enter the name of a VM you want to Power Off"
            cls
            checkVM $VMName

            Write-Host "Shutting Down $VMName..."
            Sleep 3
            Stop-VM -Name $VMName -Force
            Write-Host "Done!"
            cls
            HyperV
            }

        "4" {
        # Snapshot VMs
            cls
            $VMName = Read-Host -Prompt "Enter the name of the VM you want to create a Snapshot of"
            cls
            $SnapShot = Read-Host -Prompt "Enter the name of your Snapshot"
            checkVM $VMName

            Write-Host "Creating Snapshot..."
            Sleep 3
            Checkpoint-VM -Name $VMName -SnapshotName $SnapShot
            Write-Host "Done!"
            sleep 3
            HyperV
            }

        "5" {
        # Create a Linked Clone of a VM
            cls
            $LinkedCloneName = Read-Host -Prompt "Enter the name of your Linked Clone VM"
            $VMPath = Read-Host -Prompt "Enter the path you wish to store your VM"
            $VHDPath = Read-Host -Prompt "Enter the path for your Virtual Hard Drive"

            Write-Host "Creating Linked Clone, wait a few moments..."
            Sleep 5
            New-VM -Name $LinkedCloneName -Path $VMPath -VHDPath $VHDPath -Generation 2 -SwitchName "HyperV-WAN"
            $yn = Read-Host -Prompt "Done! Would you like to start your Linked Clone? (y/n)"
            if ($yn -eq "^[yY]$") {
                Write-Host "Powering on $LinkedCloneName..."
                Sleep 3
                Start-VM -Name $LinkedCloneName
                cls
                Write-Host "$LinkedCloneName is running."
                Write-Host " "
                HyperV
            } else {
                HyperV
                }
            }

        "6" {
        # Change the Network a VM is on
            cls
            $VMName = Read-Host -Prompt "Enter the name of a VM to change the network"
            cls
            checkVM $VMName

            $networks = Get-VMSwitch
            if ($networks.Count -eq 0) {

                Write-Host "0 Networks Found."

            } else {

                Write-Host "List of Networks:`n"
                foreach ($network in $networks) {
                    Write-Host "Network Name: $($network.Name)"
                    Write-Host "Switch Type: $($network.SwitchType)"
                    Write-Host "Isolation Type: $($network.AllowedTrafficTypes)"
                    $VMConnect = $network | Get-VMNetworkAdapter | ForEach-Object { $_.VMName }
                    Write-Host "Connected VMs: $($VMConnect -join ', ')"
                    Write-Host "-----------------------"
                }
                Read-Host "Press 'Enter' when Done"
            }
            HyperV
            }

        "7" {
        #Delete a VM from Disk
            }

        "42" {
        # The Answer to the Ultimate Question of Life, the Universe, and Everything...
            cls
            Write-Host "You have found the answer to the Universe, Life, and Everything. Congratulations"
            Sleep 2
            cls
            Exit
            }

        "^[qQ]$" {
        # Quits Program when selected
            cls
            Write-Host "Closing..."
            Sleep 2
            Exit
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