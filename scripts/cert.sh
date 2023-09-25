# Save the following shell script as ssl.sh

#! /bin/bash

if [ "$#" -ne 1 ]
then
  echo "Error: No domain name argument provided"
  echo "Usage: Provide a domain name as an argument"
  exit 1
fi

DOMAIN=$1

# Create root CA & Private key

openssl req -x509 \
            -sha256 -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=${DOMAIN}/C=US/L=Katy" \
            -keyout rootCA.key -out rootCA.crt 

# Generate Private key 
openssl genrsa -out ${DOMAIN}.key 2048

# Create csf conf

cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = Texas
L = Katy 
O = Kendops
OU = Engineering Department 
CN = vault.${DOMAIN}

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = *.${DOMAIN}
DNS.2                           = vault.${DOMAIN}
DNS.3                           = vault.svc.cluster.local
DNS.4                           = localhost
DNS.5                           = vault
DNS.6                           = consul
DNS.7                           = server.dc1.${DOMAIN}
DNS.8                           = dc1.${DOMAIN}
DNS.9                           = consul.${DOMAIN}
DNS.10                          = consul.svc.cluster.local
DNS.11                          = server.dc1.cluster.local 
DNS.12                          = cluster.local
IP.1                            = 172.29.0.231
IP.2                            = 172.29.0.232
IP.3                            = 127.0.0.1

EOF

# create CSR request using private key
openssl req -new -key ${DOMAIN}.key -out ${DOMAIN}.csr -config csr.conf

# Create a external config file for the certificate

cat > vault-csr.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.${DOMAIN}
DNS.2                           = vault.${DOMAIN}
DNS.3                           = vault.svc.cluster.local
DNS.4                           = localhost
DNS.5                           = vault
DNS.6                           = consul
DNS.7                           = server.dc1.${DOMAIN}
DNS.8                           = dc1.${DOMAIN}
DNS.9                           = consul.${DOMAIN}
DNS.10                          = consul.svc.cluster.local
DNS.11                          = server.dc1.cluster.local 
DNS.12                          = cluster.local
IP.1                            = 172.29.0.231
IP.2                            = 172.29.0.232
IP.3                            = 127.0.0.1

EOF

# Create SSl with self signed CA

openssl x509 -req \
    -in ${DOMAIN}.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out ${DOMAIN}.crt \
    -days 365 \
    -sha256 -extfile vault-csr.conf

chmod +x cert.sh

## to run it:
## ./ cert.sh vault.kendopz.com.key

#####################################################################################################

# openssl req -config vault-csr.conf -newkey rsa -x509 -days 1000 -out vault.crt
# openssl x509 -in vault.crt -signkey vault.key -x509toreq -out vault.csr 
# openssl req -text -noout -verify -in vault.csr
# openssl x509 -text -noout -in vault.crt
# openssl x509 -in vault.crt -out vault-cert.pem
# openssl x509 -in consul.crt -out consul-cert.pem


## Next, you will have to generate a CSR:
# openssl req -out vault.kendopz.com.csr -newkey rsa -nodes -keyout vault.kendopz.com.key -config vault-csr.conf

## Finally, we can generate the certificate itself:
# openssl x509 -req -days 30 -in vault.kendopz.com.csr -signkey vault.kendopz.com.key -out vault.kendopz.com.crt

# openssl req -config vault-csr.conf -new -x509 -sha256 -newkey rsa:2048 -nodes \
#   -keyout vault.kendopz.com.key.pem -days 365 -out vault.kendopz.com.cert.pem

## Verify 
# openssl req -noout -text -in vault.kendopz.com.csr
# openssl x509 -noout -in vault.kendopz.com.crt -subject
# openssl x509 -text -noout -in vault.kendopz.com.crt | grep -i DNS 
# openssl x509 -in vault.kendopz.com.crt -noout -text | awk '/DNS:/' | sed 's/DNS://g'
