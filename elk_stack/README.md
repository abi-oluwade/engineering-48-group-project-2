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

### Installing and configuring Filebeat
- A chef cookbook was used to install filebeat and its dependencies
- The recipe for this cookbook has the code:

````
include_recipe 'apt'

bash 'install_filebeat' do
  user 'root'
  code <<-EOH
  echo "deb https://packages.elastic.co/beats/apt stable main" | sudo tee -a /etc/apt/sources.list.d/beats.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D27D666CD88E42B4
  sudo apt-get update && sudo apt-get install filebeat
  sudo /etc/init.d/filebeat start
  EOH
end
````
- with ``depends 'apt'`` in the metadata.rb file
- To configure Filebeat the template module was used as follows:

````
template '/etc/filebeat/filebeat.yml' do
  source 'filebeat.yml.erb'
end

execute 'restart Filebeat' do
  command 'sudo /etc/init.d/filebeat restart'
end
````
- The default filebeat.yml file was kept the same with the exception of the logstash output section which was changed:
````
### Logstash as output
logstash:
  # The Logstash hosts
  hosts: ["0.0.0.0:5044"]
````

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
  
## Cookbooks
Each of the ELK stack components has the own cookbooks saved in their individual repository on GitHub.
- **Filebeat.**
- **Elasticsearch.** 
- **Logstash.** (https://github.com/harry-sparta/eng-48-logstash)
- **Kibana.**
