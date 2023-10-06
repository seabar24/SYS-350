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

def VM():
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')
    datacenter=si.content.rootFolder.childEntity[0]
    vms=datacenter.vmFolder.childEntity
    print("\nEnter 'exit' to go back to main menu")
    vm_name=input("\nName a VM to Search for: ")

    matching_vms=[]

    for vm in vms:
        if vm_name == vm.name:
            matching_vms.append(vm)

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
    elif vm_name == "":
        for i in vms:
            print(i.name)
        time.sleep(4)
        VM()
    elif vm_name == "exit":
        main()
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

def main():
    switch_dict = {
        "1": currentSes,
        "2": VM,
        "3": exitFunction
        
    }
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')
    choice=input("What would you like to look at?\n\n1: Current Session\n2: VM Information\n3: Exit Program\n\nChoice: ")
    output=switch_dict.get(choice, default_case)()
main()