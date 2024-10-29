
# Valentine’s Day Web App CICD Project

## Project Overview
The **Valentine’s Day Web App CICD Project** is a fun and interactive web application designed for Valentine's Day. It features a unique interface where users can engage with romantic prompts and select dates. This project showcases the implementation of Continuous Integration and Continuous Deployment (CICD) practices using modern DevOps tools.

## Project Architecture Diagram

![AWS Project Architecture Diagram](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/project%20architecture%20diagram.gif)

## Features

- **Interactive User Interface**: Engaging front-end that allows users to select dates and respond to romantic questions.
- **CICD Pipeline**: Automated build, test, and deployment processes for seamless updates and releases.
- **Code Quality Checks**: Integration of SonarQube for static code analysis and quality assurance.
- **Security Scanning**: Use of Trivy to scan Docker images for vulnerabilities.
- **Dockerization**: Containerized application for consistent deployment across different environments.
- **Live Deployment**: Real-time updates and deployment to a production environment.

## Tools & Technologies

1. **Development**
   - **Java**: Backend programming language for the application.
   - **Jenkins**: Automation server for setting up the CICD pipeline.
   - **SonarQube**: For code quality checks and static analysis.

2. **Containerization**
   - **Docker**: To create, deploy, and run applications in containers.
   - **Docker Hub**: Repository for storing and sharing Docker images.

3. **Security**
   - **Trivy**: Security scanner for detecting vulnerabilities in Docker images.

4. **Deployment**
   - **Jenkins**: Continues to be used for deploying the application through its pipeline.

5. **Version Control**
   - **GitHub**: For version control and collaboration on the source code.

## Setup Instructions

## Step 1 - Launch an EC2 Instance on AWS

### Launch EC2 Instance

**Log in** to the AWS Console, navigate to the **EC2 dashboard**, and click **Launch Instance**.

**Select an AMI**:
   - Choose **Ubuntu Server** as the AMI.
   - Select an instance type (e.g., `t2.medium`).
   - Proceed through the configuration steps.

## Configure Security Group

To allow required traffic, set up your security group with these inbound rules:

- **Port 80** - For HTTP requests.
- **Port 443** - For HTTPS requests.
- **Port 22** - For SSH access.
- **Port 9000** - For SonarQube server access.
- **Port 8080** - For Jenkins server access.
- **Port 8081** - For our dating app.

![Inbound Rule Image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Inbound%20Rules.png)

**Review** the settings, then click **Launch**.  
**Key Pair**: Create or select an existing key pair for SSH access.

## Connect to EC2

To SSH into your instance, use the key pair you selected:

```bash
ssh -i "your-key-pair.pem" ubuntu@<your-ec2-public-dns>
```

## Step 2 - Installing Jenkins on the Instance

### If you need to run Jenkins, try to install Java first.

```bash
sudo apt install openjdk-17-jdk-headless -y
```

### Write the script for installing Jenkins
- Use Vi editor or nano for creating the script. 
- Script file name: `vi jenkins.sh`
```bash

  sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install jenkins

```
- Give executable permissions to `jenkins.sh`.

```bash
  chmod +x jenkins.sh
  
```
- Execute the script.

```bash
  ./jenkins.sh
```
- Enable the Jenkins Server.
```bash
  systemctl enable jenkins
  systemctl status jenkins
```
![Jenkins status image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Jenkins%20status%20image.png)

### Step 3 - Install Docker and Start the SonarQube Container

- Command for installing and configuring Docker.

```bash
  sudo apt install docker.io -y
  sudo chmod 666 /var/run/docker.sock
```
- Check Docker.
```bash
  docker -v
```

- Run the SonarQube Container.

```bash
  docker run -d -p 9000:9000 sonarqube:lts-community
```
![Pull Docker image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Pull%20Docker%20image.png)

### Step 4 - Access the SonarQube Server

- Open the SonarQube Server with `public-ip:9000`.

![SonarQube server admin image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/SonarQube%20server%20admin%20image.png)

```bash 
Initial Username - admin

Initial Password - admin

```

- Set a new password according to your preference.

- Go to the Administration option → Security → Users → Generate Token → Copy the token ID.

![SonarQube token image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/SonarQube%20token%20image%201.pngf)

![SonarQube token image 2](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/SonarQube%20token%20image%202.png)

### Step 5 - Configure the Jenkins Server
- Access the Jenkins server by `public-ip:8080`.

![Access Jenkins admin image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Access%20Jenkins%20admin%20image%201.png)

- Run the command on the terminal to get the Jenkins default password.
```bash
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Copy and paste the password into Jenkins.

![Create new Jenkins admin image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Create%20new%20Jenkins%20admin%20image%201.png)

- Then click on Install suggested plugins. After that, enter your details, and finally, you will move to the Jenkins dashboard.

![Customize Jenkins image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Customize%20Jenkins%20image%201.png)

- Install some plugins on Jenkins:

- Go to Manage Jenkins → Plugins → Available plugins → Install.

``` bash 
SonarQube.
SonarQube Scanner. 
Docker. 
Docker Pipeline. 
docker-build-step. 
Pipeline: Stage-view (Note: ater install pipeline stage
plugin you see error just ignor beacuse this version plugin capatable with jenkins current version but stell this is work)
```
![Plugin installing image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Plugin%20installing%20image%201.png)

### Step 6 - Setup Trivy for Scanning Images and Apps

- Write the script for installing Trivy on your instance.
- File name: `vi trivy.sh`.
```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
  echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
  sudo apt-get update
  sudo apt-get install trivy -y
```
- Give executable permissions to `trivy.sh`.
```bash 
chmod +x trivy.sh
```
- Execute the script.
```bash 
./trivy.sh
```
- Check the Trivy version.
```bash
trivy -v
```

### Step 7 - Setup Jenkins Pipeline
- Go to Manage Jenkins → Tools → SonarQube Scanner.

![Jenkins pipeline image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Docker%20pipeline%20image%202.png)

- Then Docker Installations.
![Docker pipeline image 2](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Docker%20pipeline%20image%202.png)

- Add credentials for GitHub & SonarQube to build the pipeline.

```bash
Go to Manage Jenkins → Credentials → Global → Add Credentials
```
- Add Sonar-cred.

![Sonar-cred image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Sonar-cred%20image.png)

- Add Git-cred.

![Git-cred image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Git-cred%20image.png)

- Add Docker-cred.
**Note: user your docker hub account username & passowrd.**
![Docker-cred image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Docker-cred%20image.png)

- Add SonarQube environment variables.

```bash
Go to Manage Jenkins → System → SonarQube Servers → Add SonarQube
```
![SonarQube server configuration image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/SonarQube%20server%20configuration%20image.png)

```bash 
Go to Dashboard → Create Job → Name: VALENTINE → Type: Pipeline → OK
```
![Creating pipeline Dashboard image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Creating%20pipeline%20Dashboard%20image%201.png)

- Click on Discard Old builds → Max # of builds to keep: 2.
![Creating pipeline Dashboard image 2](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Creating%20pipeline%20Dashboard%20image%202.png)

- Now write the pipeline script.
```bash 
  pipeline {
      agent any
      environment{
          SCANNER_HOME= tool 'sonar-scanner'
      }

      stages {
          stage('Git Checkout') {
              steps {
                  git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/https://github.com/anilrupnar/Valentine-Day-Web-App'
              }
          }

          stage('Trivy FileSystem Scan') {
              steps {
                  sh "trivy fs --format table -o trivy-fs-report.html ."
              }
          }

          stage('Sonarqube Analysis') {
              steps {
                  withSonarQubeEnv('sonar'){
                      sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Valentine -Dsonar.projectName=Valentine"
                  }
              }
          }

          stage('Build & Tag Docker Image') {
              steps {
                  script{
                      withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                          sh "docker build -t anilrupnar/valentine:v1 ."
                      }
                  }
              }
          }

          stage('Trivy Image Scan') {
              steps {
                  sh "trivy image --format json -o trivy-image-report.json anilrupnar/valentine:v1"
              }
          }

          stage('Push Docker Image') {
              steps {
                  script{
                      withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                          sh "docker push anilrupnar/valentine:v1 "
                      }
                  }
              }
          }

          stage('Deploy to container') {
              steps {
                  sh "docker run -d -p 8081:80 anilrupnar/valentine:v1"
              }
          }
      }
  }
  ```
- For writing scripts, take help from Pipeline Syntax.

### Step 8 - Create Sample Pipeline Syntax Steps

```bash 
Go to Pipeline Syntax → Click on Sample text and Select git: Git → Paste the URL of the repository → Select branch main → Choose credentials of git → Generate Script. Copy and paste it stage (“Git Checkout”).
```
![Creating sample pipeline code image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Creating%20sample%20pipeline%20code%20image%201.png)

- Similarly, create scripts for each stage using Pipeline Syntax.

### Step 9 - Build Pipeline & Run
- Click on Apply and then Build Now.

![Pipeline Build & Run image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Pipeline%20Build%20%26%20Run%20image%201.png)

![Pipeline Build & Run image 2](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Pipeline%20Build%20%26%20Run%20image%202.png)

![Pipeline Build & Run image 3](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Pipeline%20Build%20%26%20Run%20image%203.png)

### Step 10 - Check SonarQube Report Status
- You can check the SonarQube Server for details.
![SonarQube project report status image](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/SonarQube%20project%20report%20status%20image.png)

### Step 11 - Pipline console results
![Pipline console results image 2](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Pipline%20console%20results%20image%202.png)

![Pipline console results image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Pipline%20console%20results%20image%201.png)

### Step 12 - Docker Image Pushed On Docker Hub Repository 

![Docker Image Pushed image ](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Docker%20Image%20Pushed%20image.png)

### Step 13 - Final Execution
- Now access it with `public-ip:8081/yes.html`.
![Access Deploy web app image 1](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Access%20Deploy%20web%20app%20image%201.png)

![Access Deploy web app image 2](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Access%20Deploy%20web%20app%20image%202.png)

![Access Deploy web app image 3](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Access%20Deploy%20web%20app%20image%203.png)

![Access Deploy web app image 4](https://github.com/anilrupnar/Valentine-Day-Web-App/blob/main/Images/Access%20Deploy%20web%20app%20image%204.png)


**Thank you for reading my README file! 😊**

**Feel free to connect with me:**

- **LinkedIn**: [Anil Rupnar](https://www.linkedin.com/in/anilrupnar/)
- **Email**: anilrupnar2003@gmail.com
```

This version corrects grammatical mistakes while maintaining your original structure and content. Let me know if you need further assistance!
