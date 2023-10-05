from pyVim.connect import SmartConnect
import getpass
import ssl

# Get the vCenter credentials
username = input("Enter your vCenter username: ")
password = getpass.getpass("Enter your vCenter password: ")

# SmartConnects to vmware using TLSv1_2
s=ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
s.verify_mode=ssl.CERT_NONE
si= SmartConnect(host="vcenter.sean.local", user=username, pwd=password, sslContext=s)

# Switch statement that will ask user what information they want, and will print based off response.
def user_&_host()
    file=input("Enter name of file you wish to read from: ")
    try:
        with open("user_&_host.txt", "r") as file:

    return user


def currentSes ()
    user=si.content.sessionManager.currentSession.userName
    ipaddr=si.content.sessionManager.currentSession.ipAddress
    print(f"The current session's username is: {user}")
    print(f"The source IP Address is: {ipaddr}")


def vms ()
    datacenter=si.content.rootFolder.childEntity
    vms=datacenter.vmFolder.childEntity
    #Filtered vm
    if vm_name_filter:
    filtered=[for vm in vms if vm_name_filter.lower() in vm.name.lower()]
    else:
        filtered = vms
    for i in filtered:
        return i.name

switch_dict = {
    1: currentSes,
    2: vms,
}
choice=input("What would you like to look at?\n\n1: Current Session\n2:Your VM names")
output=switch_dict.get(choice)