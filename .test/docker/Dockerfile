FROM jrei/systemd-ubuntu:latest
RUN echo 'root:Docker!' | chpasswd
RUN mkdir -p /etc/docker/ && \
    echo '{ "storage-driver": "vfs" }' > /etc/docker/daemon.json
RUN apt-get update && apt-get install --yes sudo software-properties-common && add-apt-repository --yes --update ppa:ansible/ansible && apt-get install --yes ansible python3
