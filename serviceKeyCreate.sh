while getopts "k:i:" opt; do
  case $opt in
    k) keyName=$OPTARG;;
    i) instanceName=$OPTARG;;
    *) echo 'invalid flag' >&2
       exit 1
  esac
done
if [ "$keyName" == "" ]; then
    echo 'Option -k <service credentials name> is missing' >&2
    exit 1
fi
if [ "$instanceName" == "" ]; then
    echo 'Option -i <instance name> is missing' >&2
    exit 1
fi

ibmcloud resource service-key-create $keyName --instance-name $instanceName
