# MongoDB Replica Set

  This is what our replica set visually looks like:

 ![20200203162540686](img-paste-20200203162540686.png)

Below are the steps that we carried out in order to create this replica set.

## Creating an Ami

To create an AMI we used two tools; CHEF and Packer. The purpose of using an AMI is so that standardization occurs throughout all the instances we are using for MongoDB.


### Chef

This is a configuration management tool for dealing with machine setup on physical servers, vm’s and in the cloud.

In this section we had installed CHEFDK on our machine and had to configure the path to access this tool.


1. Creating the Cookbook:

      - command **chef generate cookbook <cookbookname>**
      - accepting the licence using **echo $CHEF_LICENSE**

2. Configuring the kitchen.yml file:

  - this is where you build and define the platform you are going to use, this includes; driver, provisioner, verifier, platform, suites.

3. Writing tests for both your unit and integration tests.

  - To run unit tests, use the command:
      - **chef exec rspec**

  - To run integration tests, use the command:
      - **kitchen verify**

4. The recipe file is where we have inserted the commands to run the packages we need, for this project we have used; mongodb and filebeats (this will be taken from the separate repo created and wrapped in the cookbook)

5. Metadata.rb – the contents provide information that helps chef deploy cookbooks to each node.

This is a dependency organiser. The wrapped cookbook will also be called here in order to get access to the github repo made to install filebeats.


6. An attribute is a specific detail about a node. This is where we will also be wrapping the cookbook of the filebeats installation, so it doesn’t need to be repeated in the recipe.

 Use the command to generate an attribute:
-  **chef generate attribute <name>**


7. Templates are used to configure services within mongo and the service it provides.

Use the command:
-	**chef generate template <template name>**

8. Create tests to ensure that the templates are being created and used, use the following commands to install and update all the changes being added and changed in the cookbook:

	-  **chef install**
	-  **chef update**


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

3.	**berks install** - is the command would then create a berks lock file

4.	**berks install** - this is where the dependencies of the package are added so the cookbook has all of them available.

5.	You would then validate and build using the following commands:

    - **packer validate <name of packerfile>**
    - **Packer build <name of packer file>**

### Manually Configuring the Mongo Replica Sets




## Mongo Replica Terraform

- Terraform configuration for the private subnets and the 3 instances which are to be launched.

- To launch the instances run the command:

  - `` terraform plan ``

  - `` terraform apply ``
