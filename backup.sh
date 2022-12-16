#!/bin/bash

cat > /tmp/clusterConf.js <<EOF
var name = ""
var password = ""
try {
  shell.connect('root@n1:3306', password)
  var cluster = dba.createCluster(name);
  cluster.addInstance({user: "root", host: "n2", password: password});
  cluster.addInstance({user: "root", host: "n3", password: password});
  cluster.addInstance({user: "root", host: "n4", password: password});
} catch(e) {
  print('\nCluster creation failed.\n\nError: ' + e.message + '\n');
}
EOF

until (
    mysqlsh --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --host=${MYSQL_HOST} --port=${MYSQL_PORT} --interactive --file=/tmp/clusterConf.js
)
do
    sleep 10
done