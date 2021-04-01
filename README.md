
# IBM Cloud Postgresql failover automation

This repo demostrate how to set up a **cross-region** postgresql database service on IBM Cloud with the ability to automate failover from primary instance to the replica instance when primary is down.
  

## Example Setup

1. Primary PostgreSQL instance in Dallas
    - Has a service credential

2. Read-only PostgreSQL instance in Washington DC
    - Has a service credential

3. Kubernetes Cluster to connect frontend with PostgreSQL Database
    - Connect with secret (service-binding, see "cloud" folder)
  

## Installing Dependencies

1. jq - used to parse JSON

* /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

* brew install jq

 ## Shell Script:
 1. failover.sh: Failover from primary to replica
    - leader goes down and binding must be patched to connect to the replica  

2. promotion.sh: Replica promotion
    - in order to gain write privileges for the application  

3. primarySetup.sh: Primary setup
    - updating the service credentials so app can operate on new leader  

4. replicaCreate.sh: Replica create
    - sets up a new replica for the leader that was just created  

5. serviceCredCreate.sh: Creating service credential replica
    - so that the app can be bound to the new replica

## Example usage    
./failover.sh -c Bokai-DB-Cluster-Test -b binding-postgresql-primary-bokai-aa -k replica-bokai-aa-credentials -a icdpostgres-app

./promotion.sh -d aa-replica-bokai

./primarySetup.sh -c Bokai-DB-Cluster-Test -b binding-postgresql-primary-bokai-aa -i aa-wdc-bokai -k wdc-primary -a icdpostgres-app

./replicaCreate.sh -c wdc-primary -n aa-dallas-bokai -r us-south -m 2048 -d 10240 -k dallas-replica

./serviceKeyCreate.sh -k credential-name -i aa-dallas-bokai

## Failover.sh


1. -c Cluster name

2. -b binding (secret) name that you used in the deployment file

3. -k service credentials ID for the instance you want to failover to

4. -a app name that you specified in the deployment file



## promotion.sh

1. -d deployment name

  
## primarySetup.sh

1. -c Cluster name

2. -b binding (secret) name that you used in the deployment file

3. -i primary DB instance name
4. -k primary service credential name

5. -a app name that you specified in the deployment file

## replicaCreate.sh

1. -c service credential name for the primary instance
2. -n new replica name
3. -r region that you want your replica to be in
4. -m members memory allocation (mb) for replica
5. -d members disk allocation (mb) for replica
6. -k the name for a new replica credential
## serviceKeyCreate.sh

1. -k new service credential name
2. -i instance name
  
## Extra:

#### Create service credentials
* ./serviceKeyCreate.sh -k [new credential name] -i [db instance name]

#### Service Binding

* ibmcloud ks cluster service bind --cluster <cluster_name_or_ID> --namespace < namespace > --service <service_instance_name>

  

#### Getting Binding Secret Name

* kubectl get secrets



#### Getting Service Key ID

* ibmcloud resource service-keys [ --instance-id ID | --instance-name NAME | --alias-id ID | --alias-name NAME ]
