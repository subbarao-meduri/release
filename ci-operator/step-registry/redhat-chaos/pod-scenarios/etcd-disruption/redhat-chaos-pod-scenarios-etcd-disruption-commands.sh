#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -x
cat /etc/os-release

oc config view

oc projects
python3 --version
pushd /tmp

ls -la /root/kraken
git clone https://github.com/redhat-chaos/krkn-hub.git
pushd krkn-hub/

echo "kubeconfig loc $$KUBECONFIG"
echo "Using the flattened version of kubeconfig"
oc config view --flatten > /tmp/config
export KUBECONFIG=/tmp/config

export KRKN_KUBE_CONFIG=$KUBECONFIG
export NAMESPACE=$TARGET_NAMESPACE 

oc get nodes --kubeconfig $KRKN_KUBE_CONFIG

echo $ENABLE_ALERTS
./prow/pod-scenarios/prow_run.sh
rc=$?
echo "Done running the test!" 
echo "Return code: $rc"
exit $rc
echo $ENABLE_ALERTS
