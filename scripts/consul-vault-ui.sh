    #!/bin/bash

    kubectl patch svc consul-ui -n consul-vaul -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1 
    kubectl patch svc vault -n consul-vaul -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1 
    export consul_url=$(kubectl get svc -n consul-vault | grep argocd-server | awk '{print $4}' | grep -v none)
    export vault_url=$(kubectl get svc -n consul-vault | grep argocd-server | awk '{print $4}' | grep -v none)
    echo "consul_url: http://$consul_url/"
    echo "consul_url: http://$consul_url/"


