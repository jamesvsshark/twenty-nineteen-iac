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
  instance_type = "${var.instance_type}"

  security_groups = [
    "${aws_security_group.webserver_security_group.name}",
  ]

  tags = {
    Name = "${var.name}"
  }
}
