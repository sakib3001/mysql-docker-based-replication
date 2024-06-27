-- MySQL replication setup script
-- Change master to replicate from the master-db
CHANGE MASTER TO
  MASTER_HOST='master-db',  -- Hostname of the MySQL master
  MASTER_PORT=3306,         -- Port of the MySQL master (internal port as using hostname)
  MASTER_USER='replicator', -- Replication user on the MySQL master
  MASTER_PASSWORD='replica_password',  -- Password for the replication user
  MASTER_LOG_FILE='mysql-bin.000001',  -- First binary log file to start replication
  MASTER_LOG_POS=4;          -- Position in the binary log file to start replication

-- Start the slave replication process
START SLAVE;
