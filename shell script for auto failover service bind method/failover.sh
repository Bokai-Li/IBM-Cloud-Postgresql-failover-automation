#!/bin/sh
while getopts "c:o:n:a:" opt; do
  case $opt in
    c) cluster=$OPTARG;;
    o) oldDB=$OPTARG;;
    n) newDB=$OPTARG;;
    a) appName=$OPTARG;;
    *) echo 'invalid flag' >&2
       exit 1
  esac
done

if [ "$cluster" == "" ]; then
    echo 'Option -c <cluster name/id> is missing' >&2
    exit 1
fi
if [ "$oldDB" == "" ]; then
    echo 'Option -o <old DB binding secret name> is missing' >&2
    exit 1
fi
if [ "$newDB" == "" ]; then
    echo 'Option -n <new DB binding secret name> is missing' >&2
    exit 1
fi
if [ "$appName" == "" ]; then
    echo 'Option -a <app name> is missing' >&2
    exit 1
fi

#set cluster config
ibmcloud ks cluster config --cluster $cluster
kubectl config current-context
#retrieve new DB instance binding (read-only replica)
newBinding=$(kubectl get secret $newDB -o jsonpath='{.data.binding}')
#replace old DB instance binding (failed primary) with new
kubectl patch secret $oldDB -p='{"data":{"binding":"'$newBinding'"}}'
#restart pods
kubectl rollout restart deployment $appName
