#!/bin/bash

namespace=$1

delpods=$(kubectl get pods -n ${namespace} | grep -i 'Terminating' | awk '{print $1 }')

for i in ${delpods[@]}; do
  kubectl delete pod $i --force=true --wait=false --grace-period=0  -n ${namespace}
done
