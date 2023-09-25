#!/bin/sh
# verify the certificate used for Rancher's ingress is a valid DOD certificate
# Does privateCA need to be true for certcheck?

kubectl -n cattle-system get secret tls-rancher-ingress -o 'jsonpath={.data.tls\.crt}' | base64 --decode | openssl x509 -noout -text

if (helm get values rancher -n cattle-system | grep "privateCA: true") then
  kubectl -n cattle-system get secret tls-ca -o 'jsonpath={.data.cacerts\.pem}' | base64 --decode | openssl x509 -noout -text  
fi
