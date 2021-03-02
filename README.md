# IBM Cloud Postgresql failover automation
This repo demostrate how to set up a postgresql database instance on IBM Cloud and include a shell script that automatically failover from primary instance to the replica instance when primary is down.

## Local
The "local" folder includes resource and instruction for setting up a postgresql application with frontend runing in localhost:8080.

## Cloud
The "cloud" folder includes resource and instruction for setting up a postgresql application via service-binding method with kubernetes clusters on IBM Cloud.

# Failover automation shell Scripts
The setup environment for automatic failover is to configure a replica Postgresql instance for the primary instance. Here is how to configure Read-only Replicas:

cloud.ibm.com/docs/databases-for-postgresql?topic=databases-for-postgresql-read-only-replicas

## Failover.sh
### requirement:
1. Create one service key for each db instance (primary and replica)

### input:
1. -c Cluster name
2. -b binding (secret) name that you used in the deployment file
3. -k service Key ID for the instance you want to failover to
4. -a app name that you specified in the deployment file

## Failover-2-secrets.sh
### requirement:
1. do service binding with both primary and replica instance so that two secrets are created with your kubernetes cluster.
### input:
1. -c Cluster name
2. -o old DB instance binding secret name (failed primary)
3.  -n new DB instance binding secret name (read-only replica)
4. -a app name that you specified in the deployment file
