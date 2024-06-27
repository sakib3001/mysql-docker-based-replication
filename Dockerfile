# First stage: build dependencies and setup environment
FROM mysql:8.0 AS builder

# Set working directory
WORKDIR /mysql

# Copy configuration files and initialization scripts
COPY ./master.cnf ./slave.cnf ./master-init.sql ./slave-init.sql ./

# Adjust permissions for the copied files
RUN chown mysql:mysql /mysql/*.cnf /mysql/*.sql && \
    chmod 644 /mysql/*.cnf /mysql/*.sql

# Second stage: setup master
FROM mysql:8.0 AS master
WORKDIR /master-db
COPY --from=builder /mysql/master.cnf /etc/mysql/conf.d/mysql.conf.cnf
COPY --from=builder /mysql/master-init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306
CMD ["mysqld"]

# Third stage: setup slave
FROM mysql:8.0 AS slave
WORKDIR /read-replica
COPY --from=builder /mysql/slave.cnf /etc/mysql/conf.d/mysql.conf.cnf
COPY --from=builder /mysql/slave-init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306
CMD ["mysqld"]
