# Multi Avilability Zones

## Aim:
- Using Terraform and AWS create a load balanced and auto scaled 2 tier architecture for the node example application.
- The Architecture should be a "Highly Available" application. 
- Meaning that it has redundancies across all three availabililty zones.The application should connect to a single database instance.

## Application Load Balancer
- Best suited for load balancing of HTTP and HTTPS traffic 
- Provides advanced request routing targeted at the delivery of modern application architectures 

### Components:

#### Load Balancer
- Serves as the single point of contact for clients
- Distributes incoming application traffic across multiple targets, in multiple Availability Zones
- Increases availability of your application

#### Listener
- Check for connection requests from clients, using the configured protocol and port

#### Target group
- Routes requests to one or more registered targets, using the specified protocol and port
- Health check can also be configured 

## Auto Scaling
- Ensures you have the correct number of EC2 instances avilable to handle the load of your application

## Highly Available application
- Creating your achitecture in such a way that your 'system' is always avaliable - or has the least amount of downtime as possible. 
