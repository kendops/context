#!/bin/bash

  export SERVICE_IP=$(kubectl get svc --namespace jupyterhub jupyterhub-proxy-public --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  echo "jupyterHub url: http://$SERVICE_IP/"
  echo admin user: user
  echo Password: $(kubectl get secret --namespace jupyterhub jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}')


