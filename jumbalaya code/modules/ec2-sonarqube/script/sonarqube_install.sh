#!/bin/bash

              # Install PostgreSQL (SonarQube dependency) and set up database
              apt-get install -y postgresql postgresql-contrib
              systemctl start postgresql
              systemctl enable postgresql

              # Create a database and user for SonarQube
              sudo -u postgres psql -c "CREATE DATABASE sonar;"
              sudo -u postgres psql -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';"
              sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonar TO sonar;"

              # Install SonarQube
              wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.zip -P /tmp
              unzip /tmp/sonarqube-9.9.0.zip -d /opt
              mv /opt/sonarqube-9.9.0 /opt/sonarqube
              groupadd sonar
              useradd -d /opt/sonarqube -g sonar sonar
              chown -R sonar:sonar /opt/sonarqube
              chmod -R 755 /opt/sonarqube

              # Configure SonarQube to run as a service
              cat <<EOT >> /etc/systemd/system/sonarqube.service
              [Unit]
              Description=SonarQube Service
              After=postgresql.service

              [Service]
              User=sonar
              ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
              ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
              Restart=always

              [Install]
              WantedBy=multi-user.target
            

              # Start SonarQube service
              systemctl start sonarqube
              systemctl enable sonarqube
