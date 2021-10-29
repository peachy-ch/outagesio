#!/bin/bash

#Version 1.0.3
# This is a modified version of the start script available at https://www.outagesio.com/ to work with my container

# Enter the full path where you will be placing the starter_linux_otm.sh script into.
# Our example shows '/agent', change this to what ever your path is.
start="/otm"

### Define Global Variables
OTMIN="otm"
IN="$start/updater_linux_ocp.sh"
DATE=`date +%d-%m-%y`
OTM_COMMAND="otm_linux"


### OTM section
# Get rid of any old version
rm -f $start/otm_linux
OTM_HTTP_STATUS=''
OTM_REMOTE_LENGTH=''

### Loop
until [[ ${OTM_HTTP_STATUS} -eq 200 && ! -z ${OTM_REMOTE_LENGTH} ]]
do
sleep 5
##
echo "Receiving binary location"
BINARY_LOCATION=$(curl -m 20 -s -u $USERNAME:$PASSWORD --connect-timeout 10 -X POST https://www.foxymon.com/receiver/receiver2.php -F function=receive_binary_location)
echo "Getting the OTM Package"
curl -I -m 30 --connect-timeout 15 "$BINARY_LOCATION" -o $start/otminfo.log
OTM_HTTP_STATUS=$(cat $start/otminfo.log | awk '/HTTP/ {print $2}')
OTM_REMOTE_LENGTH=$( cat $start/otminfo.log | awk '/Content-Length/ {print $2}' | sed -e 's/[\r\n]//g' )
done

###
if [[ ${OTM_HTTP_STATUS} -eq 200 && ! -z ${OTM_REMOTE_LENGTH} ]]; then
echo "Downloading OTM"
curl -m 30 --connect-timeout 15 "$BINARY_LOCATION" -o $start/otm_linux
sleep 2
OTM_LOCAL_LENGTH=$( ls -l $start/otm_linux | awk '{print $5}' | sed -e 's/[\r\n]//g' )
if [ "${OTM_LOCAL_LENGTH}" == "${OTM_REMOTE_LENGTH}" ]; then
echo "OTM downloaded, starting program then exiting this script"
cd $start
chmod +x $start/otm_linux
# exec $start/otm_linux &
fi
fi
$start/otm_linux
