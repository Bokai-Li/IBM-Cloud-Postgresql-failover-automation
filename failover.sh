#!/bin/sh
while getopts "c:b:k:a:" opt; do
  case $opt in
    c) cluster=$OPTARG;;
    b) DBbinding=$OPTARG;;
    k) serviceKeyID=$OPTARG;;
    a) appName=$OPTARG;;
    *) echo 'invalid flag' >&2
       exit 1
  esac
done

if [ "$cluster" == "" ]; then
    echo 'Option -c <cluster name/id> is missing' >&2
    exit 1
fi
if [ "$DBbinding" == "" ]; then
    echo 'Option -b <DB binding secret name> is missing' >&2
    exit 1
fi
if [ "$serviceKeyID" == "" ]; then
    echo 'Option -k <serviceKey ID/name> is missing' >&2
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
serviceKey=$(ibmcloud resource service-key $serviceKeyID --output json)
# remove '[' and ']'
echo "${serviceKey:1:${#serviceKey}-2}" > jsonObject.json
# parse json credentials
credentials=$(jq '.credentials' jsonObject.json)
#encode credentials with base64
encodedString=$(echo $credentials | base64)
#remove output file
rm jsonObject.json
#replace old DB instance binding (failed primary) with new
kubectl patch secret $DBbinding -p='{"data":{"binding":"'$encodedString'"}}'
#restart pods
kubectl rollout restart deployment $appName
