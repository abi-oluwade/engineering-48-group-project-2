# Notes (MAY OR MAY NOT BE USED)

# Initiate Mongod replicas
rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "mongodb0:27017" },
      { _id: 1, host: "mongodb1:27017" },
      { _id: 2, host: "mongodb2:27017" }
   ]
})


# Commands
rs.status() #Check status
mongo 'mongodb://mongodb0,mongodb1,mongodb2/?replicaset=rs0' # Check all replica sets are working
rs.conf() # Check the replica set configuration

# Virtual IP
 With a Virtual IP setup, none of your IP addresses are shown publicly, increasing the security of the deployment. A Virtual IP address is configured with a security group setting that restricts its access to only the internally-routable, private IPs assigned to the VPC.

# Load Balancers
A load balancer acts as the “traffic cop” sitting in front of your servers and routing client requests across all servers capable of fulfilling those requests in a manner that maximizes speed and capacity utilization and ensures that no one server is overworked, which could degrade performance. If a single server goes down, the load balancer redirects traffic to the remaining online servers. When a new server is added to the server group, the load balancer automatically starts to send requests to it.

Advantages:
- Distributes client requests or network load efficiently across multiple servers.
- Ensures high availability and reliability by sending requests only to servers that are online.
- Provides the flexibility to add or subtract servers as demand dictates.


# Failover
In failover, if a private IP address (in our case Virtual IP 10.1.1.5) fails, the application servers continue connecting to standby database node without any intervention so that the failover seems seamless.

In our project, we will be deploying replicating sets of our MongoDB so that they maintain the same data set. There will be three web-based applications running on three web servers behind a load balancer across three Availability zones (for each MongoDB instance).


# EIP
- Where it fits in?
