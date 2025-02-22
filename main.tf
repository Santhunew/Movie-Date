# Step 1: Create a security group
resource "aws_security_group" "Mine_SG" {
    name        = var.sg_name
    description = "Allow inbound traffic on required ports"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Step 2: Create EC2 Instances for Jenkins and SonarQube
resource "aws_instance" "Jenkins_server" {
    ami             = "ami-00bb6a80f01f03502"
    instance_type   = "t2.medium"
    key_name        = var.key_name
    security_groups = [aws_security_group.Mine_SG.name]

    user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y openjdk-11-jdk wget curl git

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker jenkins

# Install Trivy
sudo apt install -y wget
wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.37.2_Linux-64bit.deb
sudo dpkg -i trivy_0.37.2_Linux-64bit.deb

# Reboot to apply changes
sudo reboot
EOF

    tags = {
        Name = "Jenkins_Server"
    }
}

resource "aws_instance" "sonarqube_server" {
    ami             = "ami-00bb6a80f01f03502"
    instance_type   = "t2.micro"
    key_name        = var.key_name
    security_groups = [aws_security_group.Mine_SG.name]

    user_data = <<EOF
#!/bin/bash
# Update system packages
sudo apt update -y

# Install OpenJDK (Required for SonarQube)
sudo apt install -y openjdk-11-jdk wget unzip curl

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install SonarQube using Docker
sudo docker run -d --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:lts

EOF

    tags = {
        Name = "Sonarqube_Server"
    }
}

# Step 3: Create IAM Roles for ECS
resource "aws_iam_role" "ecs_service_role" {
  name = var.ecs_service_role_name

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role_name

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Step 4: Add ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
    name = var.ecs_cluster_name
}

# Step 5: Define ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
    family = "my_task"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn # Fixed execution role

    container_definitions = <<DEFINITION
    [
        {
            "name": "my_container",
            "image": "nginx",
            "cpu": 512,
            "memory": 1024,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80
                }
            ]
        }
    ]
    DEFINITION
}

# Step 6: Create ECS Service with IAM Role
resource "aws_ecs_service" "my_service" {
    name            = var.ecs_service_name
    cluster         = aws_ecs_cluster.my_cluster.id
    task_definition = aws_ecs_task_definition.my_task.arn
    desired_count   = 1
    launch_type     = "EC2"

    iam_role        = aws_iam_role.ecs_service_role.arn # Fixed IAM role reference

    depends_on      = [aws_ecs_cluster.my_cluster]
}
