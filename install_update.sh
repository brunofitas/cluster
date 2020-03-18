
# Installing flux
helm repo add fluxcd https://charts.fluxcd.io

kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml

kubectl create namespace flux || true

# https://github.com/fluxcd/flux/tree/master/chart/flux

helm upgrade -i flux fluxcd/flux \
--set git.url=git@github.com:brunofitas/cluster \
--set git.branch=master \
--set registry.automationInterval=1m \
--set prometheus.enabled=true \
--namespace flux

helm upgrade -i helm-operator fluxcd/helm-operator \
--set helm.versions=v3 \
--set git.ssh.secretName=flux-git-deploy \
--namespace flux

# deploy key to be pasted on github
fluxctl identity --k8s-fwd-ns flux

# tell fluxctl the namespace where flux is installed
export FLUX_FORWARD_NAMESPACE=flux

# sync
fluxctl sync

