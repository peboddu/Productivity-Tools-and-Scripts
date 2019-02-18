#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
if ping -c1 $@ > /dev/null 2>&1;
then
    _ram=$(ssh $@ free -gh | grep Mem | awk 'BEGIN {FS="[ ]+"};{print $2}'|perl -pe 's/[GT]$//')
    _processor=$(ssh $@ cat /proc/cpuinfo | grep processor | wc -l) ## lscpu
    if [ ${_processor} -ge 8 ];
    then
        printf "%s[HOST: %s \tRAM: %s \tCPU: %s]%s\n" ${green} $@ ${_ram} ${_processor} ${reset}
    else
        printf "%s[HOST: %s \tRAM: %s \tCPU: %s]%s\n" ${red} $@ ${_ram} ${_processor} ${reset}
    fi
    #printf "[HOST: %s\tRAM: %s\tCPU: %s]\n" $@ $(ssh $@ free -gh | grep Mem | awk 'BEGIN {FS="[ ]+"};{print $2}') $(ssh $@ cat /proc/cpuinfo | grep processor | wc -l)
fi;
