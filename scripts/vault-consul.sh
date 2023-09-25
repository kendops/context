#!/bin/bash

   kubectl patch svc consul-ui  -n vault -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
   kubectl patch svc vault  -n vault -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
   export consulurl=$(kubectl get svc  -n vault | grep consul-ui | awk '{print $4}' | grep -v none)
   export vaulturl=$(kubectl get svc  -n vault | grep vault | awk '{print $4}' | grep -v none)
   echo "http://$consulurl/ui"
   echo "http://$vaulturl:8200/ui"
