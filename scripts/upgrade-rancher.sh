#!/bin/bash

helm list -n cattle-system
k get po -n cattle-system
helm upgrade rancher rancher-latest/rancher \
  --namespace cattle-system
k -n cattle-system rollout status deploy/rancher
