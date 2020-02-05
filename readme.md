# Table of Contents
1. [Multi Availability Zones](#multi-availability-zones)
    1. [Aim](#aim)
    2. []
2. [MongoDB Replica Set](#MongoDB-Replica-Set)
3. [ELK Stack](#ELK-Stack)
4. [GitHub](#GitHub)

# <a name="multi-availability-zones"> Multi Availability Zones </a>
![](assets/readme-ca0f2051.png)
## <a name="aim"> Aim: </a>
- Using Terraform and AWS create a load balanced and auto scaled 2 tier architecture for the node example application.
- The Architecture should be a "Highly Available" application.
- Meaning that it has redundancies across all three availability zones. The application should connect to a single database instance.

## Application Load Balancer
- Best suited for load balancing of HTTP and HTTPS traffic
- Provides advanced request routing targeted at the delivery of modern application architectures

## Components:

### Load Balancer
A load balancer acts as the “traffic cop” sitting in front of your servers and routing client requests across all servers capable of fulfilling those requests in a manner that maximizes speed and capacity utilization and ensures that no one server is overworked, which could degrade performance. If a single server goes down, the load balancer redirects traffic to the remaining online servers. When a new server is added to the server group, the load balancer automatically starts to send requests to it.

Funtions:
- Serves as the single point of contact for clients
- Distributes incoming application traffic across multiple targets, in multiple Availability Zones
- Increases availability of your application

Advantages:
- Distributes client requests or network load efficiently across multiple servers.
- Ensures high availability and reliability by sending requests only to servers that are online.
- Provides the flexibility to add or subtract servers as demand dictates.

### Listener
- Check for connection requests from clients, using the configured protocol and port

### Target group
- Routes requests to one or more registered targets, using the specified protocol and port
- Health check can also be configured

## Auto Scaling
- Ensures you have the correct number of EC2 instances avilable to handle the load of your application

## Highly Available application
- Creating your architecture in such a way that your 'system' is always available - or has the least amount of downtime as possible

## Set up
- The load balancer resource is setup to redirect traffic to the app servers that are online. If there is a failure in the main availability zone then the primary app server will fail too. The downtime that will result from this is prevented by the autoscaling group.

- We have created an autoscaling group resource on Terraform. This resource is configured to deploy minimum of 3 and maximum of 6 App instances across three availability zones. This means, in the case of a failure another app instance will get deployed and replaced the one that has failed. This makes our architecture "Highly Available".

 - To allow the spin up of minimum three instances in multiple availability zones, we have created and configured three subnets, each having three route table associations.

# MongoDB Replica Set

   This is what our replica set visually looks like:

  ![](assets/img-paste-20200203162540686.png)

 Below are the steps that we carried out in order to create this replica set.

## Creating an Ami

 To create an AMI we used two tools; CHEF and Packer. The purpose of using an AMI is so that standardization occurs throughout all the instances we are using for MongoDB.


### Chef

 This is a configuration management tool for dealing with machine setup on physical servers, vm’s and in the cloud.

 In this section we had installed CHEFDK on our machine and had to configure the path to access this tool.


 1. Creating the Cookbook:

       - command `chef generate cookbook [cookbookname]`
       - accepting the licence using `echo $CHEF_LICENSE`

 2. Configuring the kitchen.yml file:

   - this is where you build and define the platform you are going to use, this includes; driver, provisioner, verifier, platform, suites.

 3. Writing tests for both your unit and integration tests.

   - To run unit tests, use the command:
       - `chef exec rspec`

   - To run integration tests, use the command:
       - `kitchen verify`

 4. The recipe file is where we have inserted the commands to run the packages we need, for this project we have used; mongodb and filebeats (this will be taken from the separate repo created and wrapped in the cookbook)

 5. Metadata.rb – the contents provide information that helps chef deploy cookbooks to each node.

 This is a dependency organiser. The wrapped cookbook will also be called here in order to get access to the github repo made to install filebeats.


 6. An attribute is a specific detail about a node. This is where we will also be wrapping the cookbook of the filebeats installation, so it doesn’t need to be repeated in the recipe.

  Use the command to generate an attribute:
 -  `chef generate attribute [name]`


 7. Templates are used to configure services within mongo and the service it provides.

     Use the command:
       -	`chef generate template [template name]`

 8. Create tests to ensure that the templates are being created and used, use the following commands to install and update all the changes being added and changed in the cookbook:

 	-  `chef install`
 	-  `chef update`


### Packer

 Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. This runs on every major operating system and is highly performant.

 The advantages of this are as followed:

 -	Allows you to launch completely provisioned and configured machines in seconds, this helps deployment and production.

 -	Packer creates identical images for multiple platforms which can run in AWS. Each environment is running an identical machine image.

 -	Packer installs and configures all the software for a machine at the time the image is built.

 -	Greater testability as after the machine image is built it can quickly launch and be smoke tested to verify that things appear to be working.

 -	This is good for standardized environments

 Here are the steps we followed to build packer:

 1.	First created a packer.json file where we inserted the variables, builders (which is where all the AMI parametres go) and then provisioners is where you can integrate a shell script, anisble playbook or a chef cookbook for configuring a required app in the AMI.

 2.	You need to add a Berksfile and this is where the sources of the meta data are added in.

 3.	`berks install` - is the command would then create a berks lock file

 4. `berks install` - this is where the dependencies of the package are added so the cookbook has all of them available.

 5. You would then validate and build using the following commands:

     - `packer validate [name of packerfile]`
     - `Packer build [name of packer file]`

## MongoDB Base AMI

 Using Chef and Packer, an AMI was created to provision the 3 MongoDB instances. This cookbook can be found in a separate repo [here](https://github.com/josephpontin/devops-final-db-base-ami). This AMI:
   - Install MongoDB
   - Adds a Mongo keyfile to authenticate the connection between the DBs
   - Configures the DBs to listen on the appropriate port.

## Further configuration for Primary DB

 Once the three DB instances have been launched, a bash script is ran on one of them to designate it as the primary instance.
 This script runs the following command in the Mongo shell:

 ```
 rs.initiate({_id: "rs0", members: [{_id: 0, host: "<private_ip_1>:27017"}, {_id: 1, host:"<private_ip_2>:27017"}, {_id: 2, host: "<private_ip_3>:27017"}]})
 ```

 The first private ip is that of the primary (on which this is ran), and the second and third are those of the two secondaries.

 This completes the configuration of the replica set.

## Mongo Replica Terraform

 - Terraform configuration for the private subnets and the 3 instances which are to be launched.

 - To launch the instances run the command:

   - `` terraform plan ``
     - This will create an execution plan for a set of changes that matches your expectations without making any changes to the real resources or to the current state

   - `` terraform apply ``
     - This applies the changes required to reach the desired state of the configuration generated by the ``terraform plan``

# ELK Stack

## What is the Elastic Stack? (ELK Stack)
- Elastic stack (formerly know as ELK stack) is a collection of 4 open source products used for **log monitoring and log analytics.**
- They are all developed, managed and maintained by the company Elastic.

#### Elastic stack:
- Elasticsearch
- Logstash
- Kibana
- Filebeat

#### Filebeat
- Filebeat is a lightweight shipper for forwarding and centralizing log data.
- It is installed as an agent on your servers
- Filebeat monitors the log files or locations that you specify, collects log events, and forwards them to Logstash for indexing.


#### Logstash
- Logstash is a tool to collect, process, and forward events and log messages.
- Collects logs and events data. It even parses and transforms data.

#### Elasticsearch
- Elasticsearch is a full-text, distributed, NoSQL database.
- Is also a search engine.
- It uses JSON documents rather than schema or tables.
- The transformed data from Logstash is stored and indexed into a database (Elasticsearch) and can be searched for (queried).


#### Kibana
- Kibana is a data visualisation tool/dashboard (a web interface) which is hosted through Nginx or Apache.
- Users can create bar, line and scatter plots, or pie charts and maps on top of large volumes of data.

![alt text](https://www.guru99.com/images/tensorflow/082918_1504_ELKStackTut2.png)

## Elastic Stack (ELK Stack) for our project
We will be using Elk Stack to monitor and log data for our mongoDB servers.

## Installing the Elastic Stack (ELK stack)

### Note: Prerequisite Install Java
The requirement for **elasticsearch** and **logstash** is to first install Java.

### Installing Elasticsearch -- Cookbook
In cookbook:
- Prerequisite - installed java package `openjdk-8-jdk`
- Used online cookbook to install elastic search


## Collaborating with Git and GitHub
- Before you merge a branch on your local machine, pull the branch you plan to merge to, from GitHub.
- Then merge on your local machine
- Then push to GitHub
- **So:**
  - pull
  - merge (locally)
  - push

### General guideline
 - Downloaded Kibana dashboards and Beats index patterns
 - Not using this dashboard but filebeat index pattern in it
 - Loaded a filebeat index template into the elasticsearch
 - The ELK Server is now ready to receive filebeat data



# GitHub

## GitHub Approval of Pull Requests

When you've made changes to the code on your personal branch, commit it and
push it to GitHub. From there, go onto your branch on the GitHub repo and
submit a pull request. Select the base to be branch below yours, add any
comments and click submit.

This new request may need some approval of your co-workers to add the new code
to the branch below yours. If this is the case, then they can find the new
request in the "Pull Requests" tab on the main page of the repo.

On this tab, there will be an option to add a review. Here, you can add a
comment to the request, suggest changes to the code or approve the pull. Once
enough people have approved the pull, then the person who originally made the
request will be able to complete the pull, if there are no conflicts with the
merge.

### Pull Before Merging
When wanting to make a merge to a lower branch, you should pull from that
branch onto yours before then merging and pushing the changes to GitHub. This
will help prevent merge conflicts that can cause some problems if left
unchecked.
