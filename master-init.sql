-- Create the replication user and grant replication privileges
CREATE USER 'replicator'@'%' IDENTIFIED BY 'replica_password';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator'@'%';
FLUSH PRIVILEGES;

-- Alter the user to use mysql_native_password
ALTER USER 'replicator'@'%' IDENTIFIED WITH mysql_native_password BY 'replica_password';
FLUSH PRIVILEGES;
