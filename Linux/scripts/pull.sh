#!/bin/bash
# $Id: pull.sh,v 1.14 2016/11/16 20:45:53 vegorant Exp $
# USAGE:
# * pull.sh ews-nprd3-2-l (OR)
# * pull.sh --file=/apps/SD/docs/server_role/upload/status/ews-nprd3-2-l.sh

START=$(date +%s);

pid_file="/apps/SD/eman_apps/yum-repo-mgmt/eir-command.pid"
lock_file="/apps/SD/eman_apps/yum-repo-mgmt/eir-command.lock"
ps_id=$$

## housekeeping work for interrupt signal
function release_lock {
    rm -f "$lock_file"
    rm -f "$pid_file"
    exit 1
}

trap release_lock SIGHUP SIGINT SIGTERM

function lookup_running_process () {
    local PID=$(cat "$pid_file" 2> /dev/null)
    echo "Lockfile present."
    echo "Checking if process($PID) is actually running or something left over from crash..."
    if kill -0 $PID 2> /dev/null;
    then
        echo "Found running process($PID), exiting"
        exit 1
    else
        echo "Not found running process($PID), removing lock and continuing"
        rm -f "$lock_file"
        lockfile -r 0 "$lock_file"
    fi
}

# Lock further operations to one process
lockfile -r 0 "$lock_file" || lookup_running_process

echo -n $ps_id > "$pid_file"

if [[ $@ == --file=*.sh ]];
then
    
    perl /apps/SD/eman_apps/yum-repo-mgmt/copy.pl $@
    
else
    
    cd
    remote_pid_file="/var/run/eir-command.pid"
    remote_eircommand_pid=`ssh -q $1 "[[ -f $remote_pid_file ]] && cat $remote_pid_file || echo 0"`
    if [ $remote_eircommand_pid != 0 ]; then
        echo "$remote_eircommand_pid exists on $1"
        if [[ `ssh -q $1 "ps -ef | awk '{print \\$2}' | grep $remote_eircommand_pid"` ]]; then
            echo "Exiting as someone is already running eir-command on $1"
            exit
        fi
    fi
    
    set -v -x
    ssh -4 -t $1 "sudo /etc/init.d/eir-command system status > /tmp/$1.txt;chmod 775 /tmp/$1.txt";
    scp -4 $1:/tmp/$1.txt $1.txt; grep '^EIR-repository' $1.txt > $1.sh;rm $1.txt;
    
    perl /apps/SD/eman_apps/yum-repo-mgmt/copy.pl --file=$1.sh
    
fi

rm -f "$lock_file"
rm -f "$pid_file"

END=$(date +%s);
echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'
