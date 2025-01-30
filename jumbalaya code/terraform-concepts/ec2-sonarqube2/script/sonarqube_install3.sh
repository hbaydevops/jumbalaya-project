#!/bin/bash
    apt-get update -y
    apt install unzip -y

    # installing docker
     # Remove any older versions of Docker
    sudo apt-get remove -y docker docker-engine docker.io containerd runc

    # Update package index and fix any broken dependencies
    sudo apt-get update -y
    sudo apt-get -f install -y

    # Install required packages
    sudo apt-get install -y ca-certificates curl gnupg

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Set up Docker's stable repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update the package index with the new Docker repo
    sudo apt-get update -y

    # Define Docker version and install it
    VERSION_STRING="5:26.0.0-1~ubuntu.22.04~jammy"  # Adjust version if necessary
    sudo apt-get install -y docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin

    # Start Docker and enable it to start on boot
    sudo systemctl start docker
    sudo systemctl enable docker

    # Test Docker installation
    sudo docker run hello-world 



  # Set system limits required by SonarQube
    echo "Setting system limits for SonarQube..."
    sysctl -w vm.max_map_count=524288

    sysctl -w fs.file-max=131072

    ulimit -n 131072

    ulimit -u 8192

    # Create a Docker network for SonarQube and PostgreSQL
    echo "Creating Docker network 'sonarnet'..."
    docker network create sonarnet

    # Run PostgreSQL container
    echo "Running PostgreSQL container..."
    docker run -d --name sonarqube_db \
      --network sonarnet \
      -e POSTGRES_USER=sonar \
      -e POSTGRES_PASSWORD=sonar \
      -e POSTGRES_DB=sonarqube \ 
      -p 5432:5432 \
      postgres:13

    # Run SonarQube container
    echo "Running SonarQube container..."
    docker run -d --name sonarqube \
      --network sonarnet \
      -p 9000:9000 \
      -e SONAR_JDBC_URL=jdbc:postgresql://sonarqube_db:5432/sonarqube \
      -e SONAR_JDBC_USERNAME=sonar \
      -e SONAR_JDBC_PASSWORD=sonar \
      sonarqube:community 