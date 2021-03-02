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

#retrieve service key from DB instance
serviceKey=$(ibmcloud resource service-key kube-271bbee55baf463e81cec7de47d4b219.c0nv51sd03dso8hqh1pg.default --output json)
# remove '[' and ']'
echo "${serviceKey:1:${#serviceKey}-2}" > jsonObject.json
# parse json credentials
credentials=$(jq '.credentials' jsonObject.json)
#encode credentials with base64
encodedString=$(echo $credentials | base64)

#replace old DB instance binding (failed primary) with new
kubectl patch secret $oldDB -p='{"data":{"binding":"'$encodedString'"}}'
#restart pods
kubectl rollout restart deployment $appName
