# ELK Stack

## What is the Elastic Stack? (ELK Stack)
- Elastic stack (formerly know as ELK stack) is a collection of 4 open source products used for **log monitoring and log analytics.**
- They are all developed, managed and maintained by the company Elastic.

Elastic stack
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
