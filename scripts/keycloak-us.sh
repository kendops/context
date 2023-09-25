#!/bin/bash

kubectl patch svc keycloak-http -n keycloak  -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
