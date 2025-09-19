# ecr_secret_cron for kubernetes

ACCOUNT="$(aws sts get-caller-identity --query Account --output text)"
# get the default region that was set in the aws cli 
REGION="$(aws configure get region)"
SECRET_NAME=${REGION}-ecr-registry

TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`

namespaces=$(/usr/local/bin/kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Loop through each namespace to create or update the secret
for ns in $namespaces; do
    echo "Creating/updating secret in namespace: $ns"
    /usr/local/bin/kubectl create secret docker-registry $SECRET_NAME \
        --namespace="${ns}" \
        --docker-server=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
        --docker-username="AWS" \
        --docker-password="${TOKEN}" \
        --dry-run=client -o yaml | /usr/local/bin/kubectl apply -f -
done
 