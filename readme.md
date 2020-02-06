# Table of Contents

1. [The Project](#project)


2. [How to Run the Project](#how-to-run-project)


3. [Multi Availability Zones](#multi-availability-zones)
    1. [Aim](#aim)
    2. [Components](#components)
        * [Load Balancer](#load-balancer)
        * [Listener](#listener)
        * [Target Group](#target-group)
    3. [Auto Scaling](#auto-scaling)
    4. [Highly Available Application](#highly-available-application)
    5. [Set Up](#set-up)


4. [MongoDB Replica Set](#mongodb-replica-set)
    1. [Creating an AMI](#creating-an-ami)
        * [Chef](#chef)
        * [Packer](#packer)
    2. [MongoDB Base AMI](#mongodb-base-ami)
    3. [Further Configuration for Primary DB](#primary-db-config)
    4. [Mongo Replica Terraform](#mongo-rep-terraform)


5. [ELK Stack](#elk-stack)
    1. [What is the Elastic Stack?](#what-is-elk)
    2. [Elastic Stack](#elk)
        * [Elasticsearch](#elasticsearch)
        * [Logstash](#logstash)
        * [Kibana](#kibana)
        * [Filebeat](#filebeat)
    3. [Elastic Stack (ELK Stack) for Our Project](#project-elk)
    4. [Installing the Elastic Stack (ELK Stack)](#elk-install)
        * [Installing Elasticsearch -- Cookbook](#elasticsearch-install)
    5. [Collaborating with Git and GitHub](#githib-colab)
    6. [General Guidline](#guidline)


6. [GitHub](#github)

# <a name="project"> The Project </a>
This project's goal was to bring together everything we have learned in DevOps over the last six weeks, and to incorporate three new concepts into working infrastructure as code. We were tasked to create a terraform file that spins up a working NodeJS web app talking to a private database. This project combines those with the new concepts of multiple availability zones, MongoDB replica sets, and an ELK stack.

The web app, the face of the architecture, has been made into three copies and put in three separate availability zones. The traffic to these apps is managed by a load balancer on the internet gateway, and autoscaling controls the number of instances that are live at one time depending on how much traffic is hitting the apps. These apps in turn talk to the MongoDB replica stack. This stack is a group of three replicated databases housed in three separate availability zones; one is the primary, the others are secondary. The web apps talk to the primary database, and if it goes down for whatever reason, one of the secondary databases will become the primary and take over the role. The status of the apps and the databases are monitored by the ELK stack. The ELK stack is made up of four components: Filebeats, Logstash, Elasticsearch, and Kibana. These parts form a structure that gathers data from the instances of apps and databases and configures it into metrics that can be used to monitor the infrastructure or produce visualised data for analysis.

# <a name="how-to-run-project"> How to Run the Project </a>

To make this architecture using your own machine, you should follow these steps:

1. Clone this repository into a directory of your choice.

2. Make sure that your machine has Terraform installed. It can be installed from [here](https://www.terraform.io/downloads.html).
3. Open up the command line on your machine, and cd into the root directory of this project.
4. Run the command `terraform init`. This will download configuration files that Terraform needs to run this code.
5. Run the command `terraform apply` and type 'yes' when prompted. This will begin the construction of the architecture, with all of the app, database and ELK instances, as well as the subnets and all of the resources needed to link them.
6. Once the build is complete, open up the AWS zone EU-West-1 and search for 'Eng48-app' in the Load Balancer tab. Copy the DNS for this load balancer and put it into your browser search bar. If you include '/posts' on the end of the DNS, it will take you to the posts page.
7. Once finished, return to your command line and run the command `terraform destroy` to destroy the arcticecture and prevent excess running costs.

# <a name="multi-availability-zones"> Multi Availability Zones </a>
![](assets/readme-ca0f2051.png)
## <a name="aim"> Aim: </a>
- Using Terraform and AWS create a load balanced and auto scaled 2 tier architecture for the node example application.
- The Architecture should be a "Highly Available" application. This means that the architecture has redundancies across all three availability zones.
- The application should connect to a single database instance in the replica stack.

## <a name="components"> Components: </a>

### <a name="load-balancer"> Load Balancer </a>
A load balancer acts as the “traffic cop” sitting in front of your servers and routing client requests across all servers capable of fulfilling those requests in a manner that maximizes speed and capacity utilization and ensures that no one server is overworked, which could degrade performance. If a single server goes down, the load balancer redirects traffic to the remaining online servers. When a new server is added to the server group, the load balancer automatically starts to send requests to it.

Funtions:
- Serves as the single point of contact for clients
- Distributes incoming application traffic across multiple targets, in multiple Availability Zones
- Increases availability of your application

Advantages:
- Distributes client requests or network load efficiently across multiple servers.
- Ensures high availability and reliability by sending requests only to servers that are online.
- Provides the flexibility to add or subtract servers as demand dictates.

We decided to use an application load balancer instead of a network load balancer. This is because:
- Best suited for load balancing of HTTP and HTTPS traffic
- Provides advanced request routing targeted at the delivery of modern application architectures

### <a name="listener"> Listener </a>
 A listener is a process that checks for connection requests and works in tandem with the load balancer. It is configured with a protocol and a port for front-end connections, and a seperate protocol and port for back-end connections.

### <a name="target-group"> Target group </a>
A target group is used to route requests to one or more registered targets, using a specified protocol and port. This means that, combined with the listener, the load balancer will pick a target within a specific target group to send traffic to for one type of request. Different request types will have different target groups.

 Health checks can also be configured for your load balancer on a per target group basis. After a target group has been specified, the load balancer continually monitors the health of all targets registered within the target group.

## <a name="auto-scaling"> Auto Scaling </a>
Autoscaling is a component that monitors applications and automatically adjusts capacity to meet and handle traffic to the apps. It will spin up and destroy instances when needed so that costs of running the architecture can be reduced by eliminating excess instances, while simultaneously maintaining keeping the apps operational in times of heavy load.

## <a name="highly-available-application"> Highly Available Application </a>
High availability refers to how likely your architecture is to operate for a long time without failure. In our case here, this translates to accommodations for failure in the form of redundant components, which creates a safety net in the case of apps failing.

## <a name="set-up"> Set up </a>
- The load balancer resource is setup to redirect traffic to the app servers that are online. If there is a failure in the main availability zone then the primary app server will fail too. The downtime that will result from this is prevented by the autoscaling group.

- We have created an autoscaling group resource on Terraform. This resource is configured to deploy minimum of 3 and maximum of 6 App instances across three availability zones. This means, in the case of a failure another app instance will get deployed and replaced the one that has failed. This makes our architecture "Highly Available".

- To allow the spin up of minimum three instances in multiple availability zones, we have created and configured three subnets, each having three route table associations.

- The app that is made on the autoscaled instances are from an AMI made in Packer. This image has the working app code, its tests, and the environment in which the app can run. The environment and app were provisioned in Chef before turned into an image. Inside the Chef cookbook, we included a filebeat cookbook which installs filebeat on the instance, and can then be used by the ELK stack to monitor the app. The repo for this AMI can be found [here](https://github.com/Rasmuskilp/nodejs_app).

# <a name="mongodb-replica-set"> MongoDB Replica Set </a>

   This is what our replica set visually looks like:

  ![](assets/img-paste-20200203162540686.png)

 Below are the steps that we carried out in order to create this replica set.

## <a name="creating-an-ami"> Creating an Ami </a>

 To create an AMI we used two tools; Chef and Packer. The purpose of using an AMI is so that standardization occurs throughout all the instances we are using for MongoDB.


### <a name="chef"> Chef </a>

 This is a configuration management tool for dealing with machine setup on physical servers, vm’s and in the cloud.

 In this section we had installed ChefDK on our machine and had to configure the path to access this tool.


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

 5. Metadata.rb – the contents provide information that helps Chef deploy cookbooks to each node.

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


### <a mane="packer"> Packer </a>

 Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. This runs on every major operating system and is highly performant.

 The advantages of this are as followed:

 -	Allows you to launch completely provisioned and configured machines in seconds, this helps deployment and production.

 -	Packer creates identical images for multiple platforms which can run in AWS. Each environment is running an identical machine image.

 -	Packer installs and configures all the software for a machine at the time the image is built.

 -	Greater testability as after the machine image is built it can quickly launch and be smoke tested to verify that things appear to be working.

 -	This is good for standardized environments


 Here are the steps we followed to build packer:

 1.	First created a packer.json file where we inserted the variables, builders (which is where all the AMI parametres go) and then provisioners is where you can integrate a shell script, anisble playbook or a Chef cookbook for configuring a required app in the AMI.

 2.	You need to add a Berksfile and this is where the sources of the meta data are added in.

 3.	`berks install` - is the command would then create a berks lock file

 4. `berks install` - this is where the dependencies of the package are added so the cookbook has all of them available.

 5. You would then validate and build using the following commands:

     - `packer validate [name of packerfile]`
     - `Packer build [name of packer file]`

## <a name="mongodb-base-ami"> MongoDB Base AMI </a>

 Using Chef and Packer, an AMI was created to provision the 3 MongoDB instances. This cookbook can be found in a separate repo [here](https://github.com/josephpontin/devops-final-db-base-ami). This AMI:
   - Install MongoDB
   - Adds a Mongo keyfile to authenticate the connection between the DBs
   - Configures the DBs to listen on the appropriate port.

## <a name="primary-db-config"> Further Configuration for Primary DB </a>

 Once the three DB instances have been launched, a bash script is ran on one of them to designate it as the primary instance.
 This script runs the following command in the Mongo shell:

 ```
 rs.initiate({_id: "rs0", members: [{_id: 0, host: "<private_ip_1>:27017"}, {_id: 1, host:"<private_ip_2>:27017"}, {_id: 2, host: "<private_ip_3>:27017"}]})
 ```

 The first private ip is that of the primary (on which this is ran), and the second and third are those of the two secondaries.

 This completes the configuration of the replica set.

## <a name="mongo-rep-terraform"> Mongo Replica Terraform </a>

 - Terraform configuration for the private subnets and the 3 instances which are to be launched.

 - To launch the instances run the command:

   - `` terraform plan ``
     - This will create an execution plan for a set of changes that matches your expectations without making any changes to the real resources or to the current state

   - `` terraform apply ``
     - This applies the changes required to reach the desired state of the configuration generated by the ``terraform plan``

# <a name="elk-stack"> ELK Stack </a>

## <a name="what-is-elk"> What is the Elastic Stack? (ELK Stack) </a>
- Elastic stack (formerly know as ELK stack) is a collection of 4 open source products used for **log monitoring and log analytics.**
- They are all developed, managed and maintained by the company Elastic.

## <a name="elk"> Elastic stack: </a>
- Filebeat
- Logstash
- Elasticsearch
- Kibana


### <a name="filebeat"> Filebeat </a>
- Filebeat is a lightweight shipper for forwarding and centralizing log data.
- It is installed as an agent on your servers
- Filebeat monitors the log files or locations that you specify, collects log events, and forwards them to Logstash for indexing.


### <a name="logstash"> Logstash </a>
- Logstash is a tool to collect, process, and forward events and log messages.
- Collects logs and events data. It even parses and transforms data.

### <a name="elasticsearch"> Elasticsearch </a>
- Elasticsearch is a full-text, distributed, NoSQL database.
- Is also a search engine.
- It uses JSON documents rather than schema or tables.
- The transformed data from Logstash is stored and indexed into a database (Elasticsearch) and can be searched for (queried).


### <a name="kibana"> Kibana </a>
- Kibana is a data visualisation tool/dashboard (a web interface) which is hosted through Nginx or Apache.
- Users can create bar, line and scatter plots, or pie charts and maps on top of large volumes of data.

![alt text](https://www.guru99.com/images/tensorflow/082918_1504_ELKStackTut2.png)

## <a name="project-elk"> Elastic Stack (ELK Stack) for Our Project </a>
We will be using Elk Stack to monitor and log data for our mongoDB servers.

## <a name="elk-install"> Installing the Elastic Stack (ELK stack) </a>

### Note: Prerequisite Install Java
The requirement for **elasticsearch** and **logstash** is to first install Java.

### <a name="elasticsearch-install"> Installing Elasticsearch -- Cookbook </a>
In cookbook:
- Prerequisite - installed java package `openjdk-8-jdk`
- Used online cookbook to install elastic search


## <a name="github-colab"> Collaborating with Git and GitHub </a>
- Before you merge a branch on your local machine, pull the branch you plan to merge to, from GitHub.
- Then merge on your local machine
- Then push to GitHub
- **So:**
  - pull
  - merge (locally)
  - push

### <a name="guidline"> General guideline </a>
 - Downloaded Kibana dashboards and Beats index patterns
 - Not using this dashboard but filebeat index pattern in it
 - Loaded a filebeat index template into the elasticsearch
 - The ELK Server is now ready to receive filebeat data



# <a name="github"> GitHub </a>

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
