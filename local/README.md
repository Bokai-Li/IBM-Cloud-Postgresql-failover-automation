# Instruction
This folder has resource that demonstrates how to automate the process of reconnecting to the IBM Cloud PostgreSQL Databases replica instance when the primary instance is down. This is designed and tested to run locally only and requires you to set up one replica DB instance with the primary.

## Setting up service credentials
Make sure to create service credentials for the two DB instances, both primary and replica, from the cloud console. You can do so from the "service credentials" tab. Then create two files called vcap-local.json and vcap-local-replica.json. Copy your primary service credentials in the vcap-local.json and your replica service credentials in vcap-local-replica.json. The header is provided in the example-vcap-local file. You need to copy your service credentials in the credential field.

## Running the DB application locally
Run "npm install" to get all the dependencies set up, then "node server.js" to start the server, it will listen on port 8080. If you encounter "SELF_SIGNED_CERT_IN_CHAIN" warning, try "NODE_TLS_REJECT_UNAUTHORIZED='0' node server.js".

## Simulating primary instance being down
You can provide invalid credentials or invalid connection strings to simulate the primary instance being down. It will automatically retry to establish connection to the replica instance. Note that this replica is read-only as all IBM Cloud PostgreSQL DB instances are read-only. The add button will throw an error but you should be able to read all the entries you have added before.
