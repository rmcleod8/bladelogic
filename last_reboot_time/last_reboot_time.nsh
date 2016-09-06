#last_reboot_time.nsh
#richard.mcleod@gmail.com
#2013-11-04
#Will attempt to capture the last reboot time of a host
#should work regardless of platform (windows/*nix)
#Will set a server property() in BladeLogic showing last reboot time of the host BCBSF_LAST_REBOOT_TIME
#Output formatted as YEAR-MONTH-DAY HOUR:MIN:SECONDS (24hour clock) per Date TYPE on Server property
#Inputs: Server Group --should contain all servers
#target: <an application server>
###################################################

zmodload -i zsh/datetime

cur_date=`date +%Y%m%d`
outdir=/F/Bladelogic/script_out/data/last_reboot_time
cd $outdir
outfile=last_reboot_time_${cur_date}.csv
errfile=last_reboot_time_err_${cur_date}.csv
serverGroup=$1
serverList=`blcli_execute Server listServersInGroup "${serverGroup}"`
now=$EPOCHSECONDS

if [[ -f ${outfile} ]]
then
       echo "Output file: $outfile already exists! Exiting!"
	   exit 1
else
       touch $outfile
fi
 
for server in $serverList
do
	lrt=
	elrt=
	fmtlrt=
 	echo "Processing Server: $server"
	lrt=`nstats $server 2>>$errfile|awk 'NR==2{if ($7 ~ /[0-9]\:/) { split($7,t,":"); days=0; hours=t[1]; mins=t[2]; } else if ($8 ~ /days/) { split($9,t,":"); days=$7; hours=t[1]; mins=t[2] } else { days=0; hours=0; mins=$3; } print ((mins*60)+(hours*3600)+(days*86400)) }'` 
	case $lrt in
		(*[^0-9]*|'') echo "Something is wrong, ELRT/LRT should always have a value!";;
		(*)	elrt=$(( $now - $lrt )) 2>>$errfile
		fmtlrt=`echo $(strftime "%Y-%m-%d %H:%M:%S" $elrt)`
    	echo "$server,LAST_REBOOT_TIME,"\"$fmtlrt\" >>$outfile;;
	esac
done

echo "Bulk Update occurring"
blcli_execute Server bulkSetServerPropertyValues ${outdir} ${outfile}