#createStaticGroupFromDepotList.nsh
#Date: 2015-05-12
#Author: rmcleod8
#

blcli_setjvmoption -Dcom.bladelogic.cli.execute.quietmode.enabled=true

while getopts ":f:g:" opt;
do
	case $opt in
		f)
			depotFilePath="${OPTARG}"
			depotFileParent="${depotFilePath%/*}"
			depotFileName="${depotFilePath##*/}"
			;;
		g)
			staticGroupPath="${OPTARG}"
			staticGroupParent="${staticGroupPath%/*}"
			staticGroupName="${staticGroupPath##*/}"
			;;		
		\?)
			echo "[ERROR] Incorrect Options Found!"
			exit 1
			;;
		:)
			echo "[ERROR] Option -$OPTARG requires an argument"
			exit 1
			;;
	esac
done

#############
# FUNCTIONS #
#############

function addServersToGroup {
	for server in $(cat ${depotFileLocation})
	do
		blcli_execute StaticServerGroup addServerToServerGroupByName "${staticGroupId}" "${server}"
		if [[ $? -eq 0 ]]; then
			echo "[INFO] ${server} added to ${staticGroupPath}"
		else
			echo "[WARN] Unable to add ${server} to ${staticGroupPath}"
		fi
	done
}

function groupCheck {
	blcli_execute StaticServerGroup groupExists "${staticGroupPath}"
	blcli_storeenv staticGroupPathExists
		if [[ "${staticGroupPathExists}" = "false" ]]; then
			blcli_execute StaticServerGroup groupExists "${staticGroupParent}"
			blcli_storeenv staticGroupParentExists
				if [[ "${staticGroupParentExists}" = "false" ]]; then
					echo "[ERROR] The static server group path you entered does not exist!"
					echo "[ERROR] Check your input: ${staticGroupParent}"
					exit 1
				else
					echo "[INFO] We found that the parent static group: ${staticGroupParent} exists!"
					echo "[INFO] Attempting to create the nested group: ${staticGroupName}"
					blcli_execute StaticServerGroup createGroupWithParentName "${staticGroupName}" "${staticGroupParent}"
						if [[ $? -eq 0 ]]; then
							echo "[INFO] Successfully created ${staticGroupPath}"
						else
							echo "[ERROR] There was an issue creating ${staticGroupPath}"
							exit 1
						fi
				fi
		else
			echo "[INFO] The path: ${staticGroupPath} already exists, continuing!"
			
	fi
	blcli_execute ServerGroup groupNameToId "${staticGroupPath}"
	blcli_storeenv staticGroupId
}

function depotFileCheck {
	blcli_execute DepotGroup groupNameToDBKey "${depotFileParent}"
	blcli_storeenv depotFileParentDBKey

	if [[ ! -z "${depotFileParentDBKey}" ]]; then
		blcli_execute DepotObject depotObjectExistsByTypeGroupAndName "${fileType}" "${depotFileParentDBKey}" "${depotFileName}"
		blcli_storeenv fileExists
		
			if [[ "${fileExists}" = "true" ]]; then
				blcli_execute DepotFile getLocationByGroupAndName "${depotFileParent}" "${depotFileName}"
				blcli_storeenv depotFileLocation
			else
				missingFile
			fi
	else
		incorrectParent
	fi
}

function incorrectParent {
	echo "[ERROR] The parent: ${depotFileParent} apparently does not exist!"
	echo "[ERROR] Check your input: ${depotFilePath}"
	exit 1
}

function missingFile {
	echo "[ERROR] The file: ${depotFileName} apparently does not exist in ${depotFileParent}!"
	echo "[ERROR] Check your input: ${depotFilePath}"
	exit 1
}

########
# MAIN #
########

fileType="74"
depotFileCheck
groupCheck
addServersToGroup
