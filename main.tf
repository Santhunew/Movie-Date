resource "aws_security_group" "webappsg" {
  name = "Mine_webappsg"
  description = "Allow HTTP and SSH inbound traffic"

ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  from_port = 8081
  to_port = 8081
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webapp" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = "Santhu"
  security_groups = [aws_security_group.webappsg.name]
  tags = {
    Name = "webapp_tg"
  }
}