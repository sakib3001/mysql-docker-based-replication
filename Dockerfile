# Base image for building the MySQL configuration and initialization scripts
FROM mysql:8.0 AS builder

WORKDIR /mysql

# Copy configuration files and initialization scripts
COPY ./master.cnf ./slave.cnf ./master-init.sql ./slave-init.sql ./

# Adjust permissions for the copied files
RUN chown mysql:mysql *.cnf && \
    chmod 644 *.cnf && \
    chown mysql:mysql *.sql && \
    chmod 644 *.sql 

# Stage for setting up the MySQL master server
FROM mysql:8.0 AS master
WORKDIR /master-db

# Copy configuration and initialization script from builder stage
COPY --from=builder /mysql/master.cnf /etc/mysql/conf.d/mysql.conf.cnf
COPY --from=builder /mysql/master-init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306
CMD ["mysqld"]

# Stage for setting up the MySQL slave server
FROM mysql:8.0 AS slave
WORKDIR /read-replica

# Copy configuration and initialization script from builder stage
COPY --from=builder /mysql/slave.cnf /etc/mysql/conf.d/mysql.conf.cnf
COPY --from=builder /mysql/slave-init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306
CMD ["mysqld"]
