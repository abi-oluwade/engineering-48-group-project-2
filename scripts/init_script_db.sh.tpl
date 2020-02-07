#!/bin/bash
mongo --eval rs.slaveOk()
const client = new MongoClient(mongoURL + "?readPreference=primaryPreferred", { useUnifiedTopology: true, useNewUrlParser: true });
