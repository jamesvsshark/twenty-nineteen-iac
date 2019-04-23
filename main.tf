provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

# our s3 bucket to store our TF state file remotely
resource "aws_s3_bucket" "iac_state" {
  bucket = "twenty-nineteen-iac"
}

terraform {
  backend "s3" {
    bucket = "twenty-nineteen-iac"
    key    = "state/master/terraform.tfstate"
    region = "us-east-1"
  }
}

# our s3 bucket which will serve our static web app
resource "aws_s3_bucket" "twenty_nineteen_web_app" {
  bucket = "app.twentynineteen.me"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# our ec2 instance running wordpress
data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-wordpress-5.1.1-1-linux-ubuntu-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Bitnami
}

resource "aws_security_group" "webserver_security_group" {
  name        = "webserver_security_group"
  description = "control access to the web server"
}

# allow http access on port 80 from all addresses/ports
resource "aws_security_group_rule" "ingress_http" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

# allow http access on port 443 from all addresses/ports
resource "aws_security_group_rule" "ingress_https" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_security_group_rule" "ingress_ssh_web" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
}

# allow reply traffic from the internet to the server on ephemeral ports
resource "aws_security_group_rule" "ingress_reply" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 1024
  to_port           = 65535
}

# allow reply traffic from the server to the internet on ephemeral ports
resource "aws_security_group_rule" "egress_reply" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 0
  to_port           = 0
}

resource "aws_instance" "twenty_nineteen_wordpress" {
  ami           = "${data.aws_ami.wordpress.id}"
  instance_type = "t2.micro"

  security_groups = [
    "${aws_security_group.webserver_security_group.name}",
  ]

  tags = {
    Name = "Wordpress"
  }
}

# resource "aws_instance" "ec2_sample" {
#   ami           = "ami-2757f631"
#   instance_type = "t2.micro"

#   tags = {
#     Name        = "Sample EC2"
#     Environment = "Dev"
#   }
# }

# resource "aws_s3_bucket" "s3_sample" {
#   bucket = "my-tf-sample-bucket"
#   acl    = "private"

#   tags = {
#     Name        = "Sample S3"
#     Environment = "Dev"
#   }
# }
