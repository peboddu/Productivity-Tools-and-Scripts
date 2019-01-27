# set -x
# usage: ssh-login-with-passwd.sh hosts "password"
pub_key=`cat /users/${LOGNAME}/.ssh/id_rsa.pub`;
for i in `cat $1`; do
    echo "Copying to ${i}"
    /usr/bin/sshpass -p "$2" ssh -o StrictHostKeyChecking=no -i /users/${LOGNAME}/.ssh/id_rsa.pub ${LOGNAME}@$i "mkdir -p ~/.ssh;echo -n \"$pub_key\" >> ~/.ssh/authorized_keys"
done

# $ cat hosts
# sla-aln1-1-7
# sla-rtp1-1-7
# sla-rch1-1-7
# sla-rtp5-1-7
# sla-sjc1-1-7
# sla-mtv1-1-7
# sla-blr1-1-7
# sla-aer1-1-7

