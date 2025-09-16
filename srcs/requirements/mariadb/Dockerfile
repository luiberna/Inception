FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY mariadb.sh /bin/script.sh

RUN chmod +x /bin/script.sh

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

ENTRYPOINT [ "/bin/script.sh" ]

CMD ["mysqld_safe", "--bind-address=0.0.0.0"]