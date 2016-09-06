Brief Description
This script will attempt to capture the last reboot time of a host, it was created to work cross-platform (windows/*nix). The script writes the data to a file to be used later*. It is configured to set a server property (LAST_REBOOT_TIME) in BladeLogic showing, you guessed it, the last reboot time of the host. Output formatted as YEAR-MONTH-DAY HOUR:MIN:SECONDS (24hour clock) per Date TYPE on Server property.
 
Instructions for importing the package:
1. Download the attached zip file to your PC.
2. Extract the zip file.
3. Add a New NSH Script using the file provided.
4. Create a new server property with the following values
    Name: LAST_REBOOT_TIME
    Description: Will report the last reboot time of the server
    Type: Simple – Date
    Editable (checked)
    Used in reports (checked) -- if you want the data to exist in BDSSA
5. Right click the depot item you imported earlier, and choose Open, then the Script tab
6. Ensure you update Line 15 with a path to your storage //@/something/something/last_reboot_time (The NSH script will attempt to work out of this directory. The @ should allow the file to save on the appserver running the job)
7. Check the Parameters tab and ensure there is a parameter called group with the following values
    Name: group
    Accepts Value (checked)
    Value required at runtime (checked)
    Editable (checked)
8. Save and Close the depot item
9. Right click the Depot Item again and choose NSH Script Job – set up the job with the following values
    Type: 1 using runscript
    Targets: One of your application servers
    Parameters:
    Group: /Path/to/SmartGroup/Showing/All Servers/
    Example: /Automation Groups/Last Reboot Time/Available Servers
    Notifications and Schedule at your discretion

If everything is configured correctly you can execute the job and check the job log for progress. Also worth tailing the output file and the error file to ensure its running smoothly. I realize the way the script is setup will cause it run serially which is inefficient but in the past encountered issues with nsh script jobs against large lists of servers. 
