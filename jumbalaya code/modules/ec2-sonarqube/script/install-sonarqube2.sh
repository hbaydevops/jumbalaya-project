#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y openjdk-11-jdk wget unzip

# Define variables
SONARQUBE_VERSION="9.9.1.69595" # Replace with the latest LTS version if needed
SONARQUBE_USER="sonarqube"
INSTALL_DIR="/opt/sonarqube"
DOWNLOAD_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"

# Create a dedicated SonarQube user
if ! id -u "$SONARQUBE_USER" >/dev/null 2>&1; then
    sudo useradd -r -m -U -d "$INSTALL_DIR" -s /bin/bash "$SONARQUBE_USER"
fi

# Download and extract SonarQube
sudo mkdir -p "$INSTALL_DIR"
sudo wget -q "$DOWNLOAD_URL" -O /tmp/sonarqube.zip
sudo unzip /tmp/sonarqube.zip -d /tmp/
sudo mv /tmp/sonarqube-${SONARQUBE_VERSION}/* "$INSTALL_DIR"

# Set permissions
sudo chown -R "$SONARQUBE_USER":"$SONARQUBE_USER" "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Configure SonarQube to run as a service
cat <<EOL | sudo tee /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/bin/linux-x86-64/sonar.sh start
ExecStop=$INSTALL_DIR/bin/linux-x86-64/sonar.sh stop
User=$SONARQUBE_USER
Group=$SONARQUBE_USER
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd, enable and start SonarQube
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

# Verify SonarQube status
sudo systemctl status sonarqube --no-pager

# Output success message
echo "SonarQube installation is complete! Access it at http://<your-ec2-public-ip>:9000"
