## Brief Description:
> This script will allow you to take a list of existing servers from a text file and create a static server group within BladeLogic. This is a Type 2 NSH script which should be executed without any targets. For Inputs, it requires a Depot Path and a target Static Group Path. My suggested method of execution is via execution task with overridden NSH parameters
 
### Follow the below steps to import the NSH Script Job
1. Download the NSH Script 
2. Create a New NSH Script object in your depot, point at the downloaded file
3. Set the script type as 'Type 2'
4. Check the box that will allow blade to run with no targets
5. Add the following Parameters
  * DEPOT_FILE_PATH
    ** flag: -f
    ** required: true
    ** editable: true
  * STATIC_SERVER_GROUP
    ** flag: -g
    ** required: true
    ** editable: true
  * null_param
    ** value: %h
    ** required: false (optional)
    ** editable: no
6. Save the script object
7. Right click the script object to create an NSH Script Job
  * Set values in the Parameters tab
    ** DEPOT_FILE_PATH: /Workspace/richard/server_list-20150512.txt
    ** STATIC_SERVER_GROUP: /Workspace/richard/server_group-20150512
8. Execute the job

### Instructions below are only for creating this as an execution task, you can ignore
### Do Not Proceed to the following steps unless the above is completed
 
Job Setup:
1. Navigate to the script job
2. Right click the script job and choose "Create Execution Task"
3. Give the Execution Task a name and location, choose Next
4. DO NOT SET ANY TARGETS, choose Next
5. You can skip the overridden properties dialog
6. On the NSH Script Parameters page, choose "Override the following NSH script parameters"
7. You will be shown an input box for DEPOT_FILE_PATH, enter the path we gathered in the pre-requisites (/Workspace/richard/server_list-20150512.txt)
8. Click the + sign to add the other parameter STATIC_SERVER_GROUP
9. Enter the path we gathered in the pre-requisites AND the name of the static server group you want (/Workspace/richard/server_list-20150512) -- here I decided to call the group server_list-20150512
Here is an example of the NSH Parameters screennsh_parms.PNG
10. Click Finish
11. Navigate to the execution task and simply execute it once to create the static server group.
12. After the script job runs successfully, you should be able to navigate to the server group path you provided to the execution task and see the servers that were fed in through the file
