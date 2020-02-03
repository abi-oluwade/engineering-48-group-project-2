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
A method of using what we call destination net to translate an external device to an internal device
