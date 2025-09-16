#!/bin/sh

# Ensure /run/mysqld exists and is owned by mysql
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/$MYSQL_DB_NAME" ]; then
    # Start MariaDB in the background
    mysqld_safe --skip-networking &
    pid="$!"

    # Wait for the socket to be created
    while [ ! -S /run/mysqld/mysqld.sock ]; do
        sleep 1
    done

    # Now run your initialization commands
    mysql -u root <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME;
CREATE USER IF NOT EXISTS '$MYSQL_ADMIN'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_ADMIN'@'%';
FLUSH PRIVILEGES;
EOF

    # Stop MariaDB
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

    # Wait for mysqld_safe to exit
    wait "$pid"
fi

# Start MariaDB server
exec mysqld_safe --bind-address=0.0.0.0