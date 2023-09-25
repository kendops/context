    #!/bin/bash

    #kubectl -n gitlab port-forward svc/gitlab-webservice-default 8181
    kubectl patch svc gitlab-webservice-default -n gitlab -p '{"spec": {"type": "LoadBalancer"}}'  > /dev/null 2>&1
    export GITLAB_IP=$(kubectl get svc gitlab-webservice-default -n  gitlab --no-headers |  awk '{print $4}' |  sed 's/com/&:8181/')
    echo "GitLab: http://$GITLAB_IP:8181/"
    echo Username: "root"
    echo Password: $(kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -o go-template='{{.data.password}}' | base64 -d && echo)
