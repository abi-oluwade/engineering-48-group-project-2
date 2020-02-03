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
In failover, if a private IP address fails, the application servers continue connecting to standby database node without any intervention so that the failover seems seamless.

So, in our project, we will be deploying replicating sets of our MongoDB so that they maintain the same data set and keep in sync. There will be three web-based applications running on three web servers behind a load balancer across three Availability zones (for each MongoDB instance).

We'll be running the application on a VPC with a CIDR range of 10.0.0.0/16. There will be six subnets across three availability zones.

The web servers will be configured to query the virtual IP we will be using ( Virtual IP: 10.1.1.5). There will be a DB_Host which is mapped to the virtual IP. This virtual IP will be accomplished by manually 'plumbing' VIP as a logical interface on our three Amazon EC2 instances running the database (DB_Host1, DB_Host2, DB_Host3). Make sure all these instances have "Source/Destination Checks Disabled"

In the routing table, we can create a route to the VIP in the routing table to the instance of DB_Host1. Now all traffic destined for the Virtual IP will go to DB_Host1 therefore making it the primary node for our project.

In order to failover the VIP to the other database servers (DB_Host2 & DB_Host3) a possibility would be to use a Lambda function that triggers every minute using Amazon Cloudwatch Events to check availability of the current DB server and if the primary DB server is unavailable or MySQL is down, it invokes another Lambda function to failover the VIP to the second server, if that's down then the third server.
You can check which server is currently being run by checking which database instance ID the route table is targeting.

# EIP
An Elastic IP address is a static IPv4 address designed for dynamic cloud computing. An Elastic IP address is associated with your AWS account. With an Elastic IP address, you can mask the failure of an instance or software by rapidly remapping the address to another instance in your account.

An Elastic IP address is a public IPv4 address, which is reachable from the internet. If your instance does not have a public IPv4 address, you can associate an Elastic IP address with your instance to enable communication with the internet; for example, to connect to your instance from your local computer.
