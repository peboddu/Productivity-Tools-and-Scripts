## Generate SSL Cert without configuration file
openssl req -nodes -newkey rsa:4096 -keyout appmon-history.cisco.com.key -out appmon-history.cisco.com.csr -subj "/C=US/ST=California/L=San Jose/O=Cisco Systems, Inc./OU=Cisco IT/CN=appmon-history.cisco.com.com"

## Generate SSL Cert with configuration file
openssl req -config openssl.conf -nodes -new -newkey rsa:4096 -out appmon-history.cisco.com.csr -keyout appmon-history.cisco.com.key


## Config file
# $ cat openssl.conf
# [ req ]
# prompt = no
# default_bits = 4096
# distinguished_name = req_distinguished_name

# [ req_distinguished_name ]
# C=<Country>
# ST=<State>
# L=<Locality>
# O=<Organziation Name>
# OU=<Department>
# CN=<FQDN>
# emailAddress=<>
