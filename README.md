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

 # Failover
 In our project, we will be deploying replicating sets of our MongoDB so that they maintain the same data set. In failover, if a private IP address (in our case Virtual IP 10.1.1.5) fails, the application servers continue connecting to standby database node without any intervention so that the failover seems seamless.


# EIP
- Where it fits in?
