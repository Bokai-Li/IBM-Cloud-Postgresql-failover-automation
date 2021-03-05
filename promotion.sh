#!/bin/sh
while getopts "d:" opt; do
  case $opt in
    d) deployment=$OPTARG;;
    *) echo 'invalid flag' >&2
       exit 1
  esac
done

if [ "$deployment" == "" ]; then
    echo 'Option -d <deployment name> is missing' >&2
    exit 1
fi

ibmcloud cdb read-replica-promote $deployment
