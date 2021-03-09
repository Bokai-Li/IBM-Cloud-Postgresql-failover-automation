#!/bin/sh
while getopts "c:n:r:m:d:k:" opt; do
  case $opt in
    c) primaryKey=$OPTARG;;
    n) replicaName=$OPTARG;;
    r) region=$OPTARG;;
    m) memoryAllocation=$OPTARG;;
    d) diskAllocation=$OPTARG;;
    k) replicaKey=$OPTARG;;
    *) echo 'invalid flag' >&2
       exit 1
  esac
done
if [ "$primaryKey" == "" ]; then
    echo 'Option -c <primary service credentials name> is missing' >&2
    exit 1
fi
if [ "$replicaName" == "" ]; then
    echo 'Option -n <replica instance name> is missing' >&2
    exit 1
fi
if [ "$region" == "" ]; then
    echo 'Option -r <region> is missing' >&2
    exit 1
fi
if [ "$replicaKey" == "" ]; then
    echo 'Option -k <replica service credentials name> is missing' >&2
    exit 1
fi
if [ "$memoryAllocation" == "" ]; then
    echo 'Option -m <memory allocation> is missing' >&2
    exit 1
fi
if [ "$diskAllocation" == "" ]; then
    echo 'Option -d <disk allocation> is missing' >&2
    exit 1
fi

#retrieve service key from DB instance
serviceKey=$(ibmcloud resource service-key $primaryKey --output json)
# remove '[' and ']'
echo "${serviceKey:1:${#serviceKey}-2}" > jsonObject.json
# parse json credentials
crnID=$(jq '.credentials.instance_administration_api.instance_id' jsonObject.json)
rm jsonObject.json
# create replica
ibmcloud resource service-instance-create $replicaName databases-for-postgresql standard $region \
-p \ '{
  "remote_leader_id": '$crnID',
  "members_memory_allocation_mb": "'$memoryAllocation'",
  "members_disk_allocation_mb": "'$diskAllocation'"
}'
