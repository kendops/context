#!/bin/bash

kubectl patch svc longhorn-frontend -n longhorn-system -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
