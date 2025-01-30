#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
SONAR_VERSION="10.3.0.82913"
SONARQUBE_USER="sonarqube"
SONARQUBE_GROUP="sonarqube"
SONARQUBE_HOME="/opt/sonarqube"
SONARQUBE_DOWNLOAD_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip"

echo "Updating system and installing required dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y unzip wget curl openjdk-17-jdk postgresql postgresql-contrib

echo "Setting up PostgreSQL database for SonarQube..."
sudo -u postgres psql <<EOF
CREATE DATABASE sonarqube;
CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
ALTER ROLE sonar SET client_encoding TO 'utf8';
ALTER ROLE sonar SET default_transaction_isolation TO 'read committed';
ALTER ROLE sonar SET timezone TO 'UTC';
EOF

echo "Creating SonarQube system user..."
sudo groupadd --system ${SONARQUBE_GROUP} || true
sudo useradd -s /bin/bash -d ${SONARQUBE_HOME} -g ${SONARQUBE_GROUP} ${SONARQUBE_USER} || true

echo "Downloading and installing SonarQube..."
sudo mkdir -p ${SONARQUBE_HOME}
cd /tmp
wget ${SONARQUBE_DOWNLOAD_URL}
sudo unzip sonarqube-${SONAR_VERSION}.zip -d /opt/
sudo mv /opt/sonarqube-${SONAR_VERSION}/* ${SONARQUBE_HOME}/
sudo chown -R ${SONARQUBE_USER}:${SONARQUBE_GROUP} ${SONARQUBE_HOME}

echo "Configuring SonarQube..."
sudo sed -i "s/#sonar.jdbc.username=/sonar.jdbc.username=sonar/" ${SONARQUBE_HOME}/conf/sonar.properties
sudo sed -i "s/#sonar.jdbc.password=/sonar.jdbc.password=sonar/" ${SONARQUBE_HOME}/conf/sonar.properties
sudo sed -i "s|#sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube|sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube|" ${SONARQUBE_HOME}/conf/sonar.properties

echo "Setting up SonarQube as a systemd service..."
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=${SONARQUBE_USER}
Group=${SONARQUBE_GROUP}
ExecStart=${SONARQUBE_HOME}/bin/linux-x86-64/sonar.sh start
ExecStop=${SONARQUBE_HOME}/bin/linux-x86-64/sonar.sh stop
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd and enabling SonarQube service..."
sudo systemctl daemon-reload
sudo systemctl enable --now sonarqube

echo "Installation completed! You can access SonarQube at: http://<your-server-ip>:9000"
