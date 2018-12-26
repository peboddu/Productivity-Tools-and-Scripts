# .bashrc
export PS1="\u@\h:\w$ "
export GREP_OPTIONS='--color=auto'
export PATH="/apps/SD/perl/bin:$PATH"
export HISTTIMEFORMAT="%d/%m/%y %T "
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault/vault-pwd.txt
export EDITOR='vim'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

#PERL_MB_OPT="--install_base \"/users/vegorant/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/users/vegorant/perl5"; export PERL_MM_OPT;
alias la='ls -la'
alias lh='ls -lh'
alias vi='vim '
alias lr='ls -lrt'
alias src='source /users/vegorant/.bashrc'
alias rc='vi /users/vegorant/.bashrc'
alias f='readlink -f '
alias a='alias'

#UTILs
alias screen='/usr/local/bin/screen '
alias work='tmux a -t work'
alias logs='tmux a -t logs'

## multi {{central,{ea,we}st}{1,2},europe1,india1}.cisco.com
alias multi='sh /users/vegorant/public_html/tmux/connect_multiple_hosts.sh '

alias y_clean='sudo yum clean all;sudo yum makecache fast'
##CVS
alias di='cvs di -u '
function cvsdiff () { cvs diff -u $@ | colordiff |less -R; }
function which_window () { _process=$(ps -ef | grep $@ | grep -v grep | awk '{print $3}'); tmux list-panes -s -F "#{pane_tty} #{pane_pid} #{session_name}:#{window_name}:#{window_index}:#{pane_index}" | grep $_process; }


function silo_collector_conf () { for site in {aer1,ams1,blr1,blr2,rch1,aln1,rtp1,rtp5,sjc1,mtv1};do( for i in {1..30};do( /users/vegorant/public_html/utils/hardware/info.sh slc-$site-$i-a );done);done; }





## RPM
alias installed_rpms="rpm -qa --qf '%{NAME}|%{VERSION}|%{RELEASE}|%{INSTALLTIME}\n'"
alias installed_rpms_requires_provides="rpm -qa --queryformat 'RPM=%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH};REQUIRES=[%{REQUIRENAME},];PROVIDES=[%{PROVIDES},];FILENAMES=[%{FILENAMES},]\n\n'"
alias clean_rpms="sudo /etc/init.d/eir-command system status | grep EIR-repository | grep -v -P 'START|END' | awk '{print $5}' | perl -lpe 's/.rpm$//' | xargs sudo rpm -e --nodeps"


case $HOSTNAME in
    plato*) PSC="\e[1;33m" ;;
    *) PSC="\e[36m" ;;
esac

alias ssh="ssh -4q "
alias scp="scp -4q "

alias trust='sh /users/vegorant/public_html/production/key_trust.sh '
alias tt='sh /users/vegorant/public_html/production/key_trust.sh '


alias rs="/usr/bin/rsync --times --rsync-path=/usr/bin/rsync --rsh=/usr/local/bin/ssh  "
alias gp="git log --pretty=format:'%h - %an, %ar : %s' "
#alias gp="git log --pretty=oneline "
alias gg='git log --all --decorate --oneline --graph'

## Prompt
PS1='\[\033[01;32m\]\u\[\033[01;30m\]@\[\033[01;35m\]\h\[\033[01;30m\]:\[\033[01;33m\]$PWD\[\033[00m\] [$(date +%FT%T)]\n\$ ' #Green

## Python pyodbc
export ODBCSYSINI=/etc/odbc
export ODBCINI=/etc/odbc/odbc.ini
export ODBCINST=/etc/odbc/odbcinst.ini

#export ORACLE_HOME=/usr/lib/oracle/12.1/client64
export ORACLE_HOME=/apps/SD/oracle10g
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
export TNS_ADMIN=$ORACLE_HOME/network/admin
export DYLD_LIBRARY_PATH=:/usr/lib/oracle/11.2/client64/lib:/usr/lib/oracle/11.2/client64/lib
export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib
export ORACLE_HOME=/usr/lib/oracle/12.1/client64
export TNS_ADMIN=/apps/SD/oracle10g/network/admin



# $ cat timeit.sh
# START=$(date +%s);
# sleep 10;
# END=$(date +%s);
# echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'