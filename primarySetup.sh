#!/bin/sh
while getopts "c:d:pk:rk:a:" opt; do
  case $opt in
    c) cluster=$OPTARG;;
    d) deployment=$OPTARG;;
    pk) primaryKey=$OPTARG;;
    rk) replicaKey=$OPTARG;;
    a) appName=$OPTARG;;
    *) echo 'invalid flag' >&2
       exit 1
  esac
done
if [ "$cluster" == "" ]; then
    echo 'Option -c <cluster name/id> is missing' >&2
    exit 1
fi
if [ "$deployment" == "" ]; then
    echo 'Option -d <deployment> is missing' >&2
    exit 1
fi
if [ "$primaryKey" == "" ]; then
    echo 'Option -p <primary service key name> is missing' >&2
    exit 1
fi
if [ "$replicaKey" == "" ]; then
    echo 'Option -r <replica service key name> is missing' >&2
    exit 1
fi
if [ "$appName" == "" ]; then
    echo 'Option -a <app name> is missing' >&2
    exit 1
fi
# create primary primary service key

# connect to db and restart pods

# create replica instance and key
