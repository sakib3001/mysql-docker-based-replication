# MySQL Docker-Based Replication

This project demonstrates how to set up MySQL replication using Docker containers. It includes a primary (master) MySQL server and one or more replicas (slaves) to provide a highly available and scalable database solution. In this setup, the master database handles write operations, while the slave databases serve as read replicas.

## Features

- **MySQL Replication**: A primary (master-db) MySQL server replicates data to one or more replica (slave-db) servers.
- **Dockerized Environment**: The entire setup runs in Docker containers for easy deployment and management.
- **Custom Configuration**: Ability to customize MySQL configurations for both primary and replica servers.
- **Read Replicas**: Slave databases act as read replicas, offloading read operations from the master database.
- **Monitoring**: Basic monitoring setup to ensure replication is working as expected.

## Prerequisites
Before you begin, ensure you have the following tools installed on your machine:
- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Run The DB-Cluster 

- #### Clone the project

```bash
  git clone https://github.com/sakib3001/mysql-docker-based-replication.git

```

- #### Go to the project directory

```bash
 cd mysql-docker-based-replication
```

- #### Creating the containers

```bash
  docker compose up -d --build
```

## Environment File Configuration
Replace `<password>` and `<username>` placeholders with your actual MySQL database credentials for both the master and slave configurations. This setup ensures that Docker Compose uses these credentials correctly when initializing the MySQL containers.
#### .env
```env
# Master Database Configuration
MASTER_MYSQL_ROOT_PASSWORD=<password>
MASTER_MYSQL_USER=<username>
MASTER_MYSQL_PASSWORD=<password>
MASTER_MYSQL_ALLOW_EMPTY_PASSWORD=yes

# Slave Database Configuration
SLAVE_MYSQL_ROOT_PASSWORD=<password>
SLAVE_MYSQL_USER=<username>
SLAVE_MYSQL_PASSWORD=<password>
SLAVE_MYSQL_ALLOW_EMPTY_PASSWORD=yes
```


## Custom Configuration
- This configuration file `master.cnf` ensures proper setup and behavior of the MySQL `master server` in a replication setup.
#### master.cnf
``` master.cnf
[mysqld]
bind-address = 0.0.0.0    # Allow MySQL to listen on all available network interfaces.
server-id = 1             # Unique ID for this MySQL server participating in replication.
log-bin = mysql-bin       # Enables binary logging for replication.
```

- This configuration file `slave.cnf` ensures proper setup and behavior of the MySQL `slave server` in a replication setup.
#### slave.cnf
``` slave.cnf
[mysqld]
bind-address=0.0.0.0       # Allows MySQL to listen on all available network interfaces.
server-id=2                # Unique server ID for replication.
relay-log=relay-log-bin    # Enables binary logging for replication.
read-only=1                # Sets the MySQL server to read-only mode.
```



## Guide to Test and Observe

### Things to be done for `master-db`
- ***Access master-db Container***
```
  docker exec -it master-db bash

```
This command opens an interactive terminal (bash) within the master-db Docker container.

- ***Access MySQL CLI***
```
mysql -u <username> -p
```
Replace `<username>` with your MySQL username. You'll be prompted to enter the `password`.

- ***Create Database and Table then Insert Data***
```
CREATE DATABASE test_db;
USE test_db;
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255) NOT NULL
);
INSERT INTO test_table (message) VALUES ('Hello, World!');
INSERT INTO test_table (message) VALUES ('Replication Test');

```
Commands like `CREATE DATABASE`, `CREATE TABLE`, and `INSERT INTO` are SQL statements executed within the MySQL client to create a database, define a table schema, and insert data, respectively.

- ***Verify Data on `master-db`***
```
SHOW DATABASES;
SELECT * FROM test_table;

```
Retrieves and displays all the databases and rows from `test_table` to confirm the data insertion.


### Things to be done for `read-replica`
- ***Access read-replica Container***
```
  docker exec -it read-replica bash

```
This command opens an interactive terminal (bash) within the read-replica Docker container.


- ***Access MySQL CLI***
```
mysql -u <username> -p
```
Replace `<username>` with your MySQL username. You'll be prompted to enter the `password`.









## Stop The DB Cluster
 
#### Stop All the containers in the docker-compose.yml
```bash
  docker compose stop
```
#### To release all the resources 
```bash
  docker compose down
```

















## Remarks

- Healthchecks for the `db` and the `redis` is not added to the compose file.
- The Image size are reduced to `frontend = 877MB` and the `backend =  337MB`
- In some cases, volume binding is crucial for data persistence. Here, I had used the `./pgdata` directory for data persistence. Alternatively, Docker volumes could be used, but for replication purposes, I prefer `volume binding`. For the ease of the project structure here I am using `pgdata` docker volume right now.

