#!/bin/bash
sudo rs.slaveOk()
const client = new MongoClient(mongoURL + "?readPreference=primaryPreferred", { useUnifiedTopology: true, useNewUrlParser: true });
