#!/bin/bash

 kubectl describe configmap config -n metallb-system
 # kubectl edit configmap config -n metallb-system
 # kubectl logs -f speaker-2mv7t -n metallb-system
 # kubectl get ipaddresspools.metallb.io -n metallb-system
 # kubectl get l2advertisements.metallb.io -n metallb-system
 # kubectl describe ipaddresspools.metallb.io production -n metallb-system
