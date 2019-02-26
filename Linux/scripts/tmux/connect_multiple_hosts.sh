## USAGE:
## sh connect_multiple_hosts.sh sla-blr1-1-7 sla-aer1-1-7 sla-rch1-1-7 sla-aln1-1-7 sla-rtp1-1-7 sla-rtp5-1-7 sla-sjc1-1-7 sla-mtv1-1-7

function starttmux() {
    if [ -z "$HOSTS" ]; then
        echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
        read HOSTS
    fi
    local hosts=( $HOSTS )
    tmux new-window "ssh ${hosts[0]}"
    unset hosts[0];
    for i in "${hosts[@]}"; do
        tmux split-window -h  "ssh $i"
        tmux select-layout tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

HOSTS=${HOSTS:=$*}

starttmux
