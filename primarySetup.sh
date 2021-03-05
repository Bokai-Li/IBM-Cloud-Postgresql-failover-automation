#!/bin/sh
while getopts "c:b:i:j:k:l:a:" opt; do
  case $opt in
    c) cluster=$OPTARG;;
    b) DBbinding=$OPTARG;;
    i) primary=$OPTARG;;
    k) primaryKey=$OPTARG;;
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
    echo 'Option -b <binding secret name> is missing' >&2
    exit 1
fi
if [ "$primary" == "" ]; then
    echo 'Option -i <primary DB instance name> is missing' >&2
    exit 1
fi
if [ "$primaryKey" == "" ]; then
    echo 'Option -k <primary service key name> is missing' >&2
    exit 1
fi
if [ "$appName" == "" ]; then
    echo 'Option -a <app name> is missing' >&2
    exit 1
fi

#set cluster config
ibmcloud ks cluster config --cluster $cluster
kubectl config current-context

# create primary service key
ibmcloud resource service-key-create $primaryKey --instance-name $primaryKey

# connect to db and restart pods
#retrieve service key from DB instance
serviceKey=$(ibmcloud resource service-key $primaryKey --output json)
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
