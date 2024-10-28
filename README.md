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

### Step 1 - Launch an EC2 Instance on AWS

### Launch EC2 Instance

1. **Log in to the AWS Console**:
   - Navigate to the [AWS Console](https://aws.amazon.com/console/) and go to the EC2 dashboard.

2. **Start a New Instance**:
   - Click on **Launch Instance**.

3. **Select AMI**:
   - Choose **Ubuntu Server** as the Amazon Machine Image (AMI).

4. **Choose Instance Type**:
   - Select an instance type, such as **t2.medium**, to balance performance and cost.

5. **Configure Instance**:
   - Proceed through the configuration settings as needed.

### Configure Security Group

1. **Create or Select a Security Group**:
   - Create a new security group or select an existing one to manage access.

2. **Add Inbound Rules**:
   - Configure the following inbound rules to allow access to various services:
     - **Port 80** - for HTTP requests
     - **Port 443** - for HTTPS requests
     - **Port 22** - for SSH access
     - **Port 9000** - for SonarQube server access
     - **Port 8080** - for Jenkins server access
     - **Port 8081** - for the Dating App

3. **Review and Launch**:
   - Review all settings, then click **Launch**.

4. **Key Pair for SSH**:
   - Choose an existing key pair or create a new key pair for SSH access to the instance.

### Connect to the EC2 Instance using MobaXterm

Once the EC2 instance is launched, you can connect to it using MobaXterm for SSH access.

#### Step 3: Download and Install MobaXterm

1. **Download MobaXterm**:
   - Go to the [MobaXterm official website](https://mobaxterm.mobatek.net/download.html) and download the **Home Edition**.

2. **Install MobaXterm**:
   - Open the downloaded installer and follow the on-screen instructions to install MobaXterm on your computer.

#### Step 4: Connect to the EC2 Instance

1. **Open MobaXterm** and select **Session** from the top menu.
2. Choose **SSH** as the session type.
3. In the **Remote Host** field, enter the **Public IP address** of your EC2 instance (found in the EC2 console).
4. Select **Specify Username** and enter `ubuntu` (for Ubuntu instances).
5. Under **Advanced SSH settings**, upload your **PEM key file** (the key pair you selected during EC2 setup).
6. Click **OK** to connect.


