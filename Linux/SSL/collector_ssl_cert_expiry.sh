#!/bin/bash
## This script is intended to identify & Re-new MySQL SSL Cert which expires in less than 3days
exec 1> >(logger -s -t $(basename $0)) 2>&1

function initialize()
{
    MYSQLSSLCERT="/etc/ssl/certs/collector_db.crt"
    MYSQLSSLKEY="/etc/ssl/certs/collector_db.key"
    IDENTIFY_DAYS_BEFORE_EXPIRY=3
}

function main()
{
    ## initialize
    initialize
    SSLCERTEXP="`openssl x509 -enddate -noout -in $MYSQLSSLCERT |awk -F'=' {'print $2'}`"
    MYSQLSSLEXP="`silo_mysql --ssl -Ne "SHOW STATUS LIKE 'Ssl_server_not_after'" | awk -F'Ssl_server_not_after' {'print $2'}`"
    DATE_DIFF=`date -d @$(( $(date -d "$MYSQLSSLEXP" +%s) - $(date +%s) )) -u +%s`
    if [ $DATE_DIFF -le (60 * 60 * 24 * $IDENTIFY_DAYS_BEFORE_EXPIRY) ] ; then         ## Exprires in less than 3 days
        renew_ssl_cert
        echo "if"
        elif [ $DATE_DIFF -le 2678400 ] ; then      ## Expires in less than 31 days
        echo "Expires in $(( $DATE_DIFF / (60 * 60 * 24) )) Days"
    else
        echo "Expires in $(( $DATE_DIFF / (60 * 60 * 24 * 31) )) Months"
    fi
}

function renew_ssl_cert()
{
    if [ `uname -a|grep el7|wc -l` -eq 1 ] ; then
        body=`/opt/em7/share/ssl/generate-cert.sh $MYSQLSSLKEY $MYSQLSSLCERT`
        body+=`systemctl restart mariadb`
        
        ## Notify on Update
        ## Seems, output is not capturing into body. So, email is body is null
        #notify $body
    else
        echo "Sorry, no fix action available for EM7 V7 yet" ;
    fi
}

function notify()
{
    body=$1
    echo $body
    subject="$(hostname) - $(date +'%FT%T-%Z') : Renewing MySQL SSL Cert"
    /opt/em7/cisco/scripts/cisco_send_email.py -s "$subject" -b "$body"
}

main
