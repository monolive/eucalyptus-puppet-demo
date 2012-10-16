#!/bin/bash
# Clean terminated server from puppet

. /root/.euca/eucarc

INSTANCE=( `euca-describe-instances | grep terminated | awk '{print $2 " " $5}'`)
INSTANCE_NUM=${#INSTANCE[@]}


for (( i=0; i<${INSTANCE_NUM}; i++ )); 
do 
    euca-terminate-instances ${INSTANCE[i]}
    i=`expr $i+1`;
    puppet node clean ${INSTANCE[i]} 
done
