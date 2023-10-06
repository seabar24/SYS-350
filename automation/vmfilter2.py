from pyVim.connect import SmartConnect
import getpass
import ssl
import os
import time

username=""
hostname=""
password=getpass.getpass("Enter your vCenter password: ")

# Switch statement that will ask user what information they want, and will print based off response.
def user_n_host():
    global username, hostname
    filename=input("Enter name of file you wish to read from: ")
    try:
        file=open(filename, "r")
        lines=file.readlines()
        for line in lines:
            if line[0:8]=="username":
                username=line[9:].strip()
            if line[0:8]=="hostname":
                hostname=line[9:].strip()
    except:
        print("This file doesn't exist.")
        user_n_host()
user_n_host()

# SmartConnects to vmware using TLSv1_2
s=ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
s.verify_mode=ssl.CERT_NONE
try:
    si=SmartConnect(host=hostname, user=username, pwd=password, sslContext=s)
except Exception as e:
    print (e)
    exit(1)
# gets current sessions details
def currentSes():
    user=si.content.sessionManager.currentSession.userName
    ipaddr=si.content.sessionManager.currentSession.ipAddress
    print(f"\nThe current session's username is: {user}")
    print(f"The source IP Address is: {ipaddr}")
    print(f"Vcenter Server: {hostname}")
    time.sleep(5)
    main()
# Checks if VM exists and prints VM info
def VM():
    # Clears page
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')
    
    # Checks if vm is in vcenter
    datacenter=si.content.rootFolder.childEntity[0]
    vms=datacenter.vmFolder.childEntity
    print("\nEnter 'exit' to go back to main menu")
    vm_name=input("\nName a VM to Search for: ")

    matching_vms=[]
    # If Vm exists, adds to the list
    for vm in vms:
        if vm_name == vm.name:
            matching_vms.append(vm)
    # prints out VM Info if VM Exists
    if matching_vms:
        for i in matching_vms:
            print(f"\nVM Name: {vm_name}")
            power=i.runtime.powerState
            print(f"\nPower State:{power}")
            cpu=i.summary.config.numCpu
            print(f"\nNumber of CPUs: {cpu}")
            memory=i.summary.config.memorySizeMB/1024
            print(f"\nMemory in GB: {memory}")
            network=i.guest.ipAddress
            print(f"\nIP Address: {network}")
            time.sleep(5)
            VM()
    # Prints out VM list if no filters are added
    elif vm_name == "":
        for i in vms:
            print(i.name)
        time.sleep(4)
        VM()
    # Exits back to main() if "exit" is typed
    elif vm_name == "exit":
        main()
    # If something else besides VM Name or Exit, tells you straight up
    else:
        print("\nYou wrong.")
        time.sleep(2)
        VM()
    main()
#Exits Program
def exitFunction():
    exit()
# Default if choice in main() is not one of the options
def default_case():
    print("Nuh uh")
    time.sleep(2)
    main()

def VM_Opt():

    # def finding_vm():
    #     # Input for VM Name
    #     datacenter=si.content.rootFolder.childEntity[0]
    #     vms=datacenter.vmFolder.childEntity
    #     print("\nEnter 'exit' to go back to main menu")
    #     vm_name=input("\nName a VM to Power On: ")

    #     matching_vms=[]
    #     # If Vm exists, adds to the list
    #     for vm in vms:
    #         if vm_name == vm.name:
    #             matching_vms.append(vm)


    def powerOn():
        # Input for VM Name
        datacenter=si.content.rootFolder.childEntity[0]
        vms=datacenter.vmFolder.childEntity
        print("\nEnter 'exit' to go back to VM Option menu")
        vm_name=input("\nName a VM to Power On: ")

        matching_vms=[]
        # If Vm exists, adds to the list
        for vm in vms:
            if vm_name == vm.name:
                matching_vms.append(vm)
        #prints out VM Info if VM name Exists
        if matching_vms:
            for i in matching_vms:
                try:
                    i.PowerOn()
                    print(f"Powering on {vm_name}...")
                    time.sleep(3)
                    return True
                except Exception as e:
                    print(f"Error powering on Vm: {e}")
                    return False
        # Exits back to VM_Opt() if "exit" is typed
        elif vm_name == "exit":
            VM_Opt()
        # If something else besides VM Name or Exit, tells you straight up
        else:
            print("\nYou wrong.")
            time.sleep(2)
            powerOn()
        VM_Opt()
    switch_dict = {
        "1": powerOn,
        # "2": powerOff,
        # "3": createSnap,
        # "4": BacktoMain,

    }
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')
    choice=input("What task would you like complete?\n\n1: Power On VM\n2: Power Off VM\n3: Create Snapshot\n4: Back to Main Menu\n\nChoice: ")
    output=switch_dict.get(choice, default_case)()
    VM_Opt()
# Main menu function
def main():
    switch_dict = {
        "1": currentSes,
        "2": VM,
        "3": exitFunction,
        "4": VM_Opt
        
    }
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')
    choice=input("What would you like to look at?\n\n1: Current Session\n2: VM Information\n3: Exit Program\n4: VM Options\n\nChoice: ")
    output=switch_dict.get(choice, default_case)()
main()