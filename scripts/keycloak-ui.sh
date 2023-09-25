#!/bin/bash

kubectl patch svc keycloak -n keycloak -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
export HTTP_SERVICE_PORT=$(kubectl get --namespace keycloak -o jsonpath="{.spec.ports[?(@.name=='http')].port}" services keycloak)
export SERVICE_IP=$(kubectl get svc --namespace keycloak keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://${SERVICE_IP}:${HTTP_SERVICE_PORT}/"
echo Username: user
echo Password: $(kubectl get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 -d)
export HTTP_SERVICE_PORT=$(kubectl get --namespace keycloak -o jsonpath="{.spec.ports[?(@.name=='http')].port}" services keycloak)
