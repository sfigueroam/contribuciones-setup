variable "appPrefix" {
  type = "string"
}
variable "appName" {
  type = "string"
}
variable "env" {
  type = "string"
}

variable "DireccionesInsProfileEc2" {
  type = "string"
}

variable "vpc" {
  type = "map"
  default = {
    "prod" = ""
    "dev" = "vpc-00c243b0c7fde0ba8"
    "qa" = "vpc-08c37b015f5020849"
  }
}

variable "subnet" {
  type = "map"
  default = {
    "prod" = ""
    "dev" = "subnet-02d0dc240871d819a"
    "qa" = "subnet-077a2b8896de16330"
  }
}


resource "aws_security_group" "direccionesSecurityGroup" {
  count = "${var.env=="dev"||var.env=="qa" ? 1 : 0}"
  name = "${var.appPrefix}"
  vpc_id = "${var.vpc[var.env]}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name = "${var.appPrefix}"
    Application = "${var.appName}"
    Env = "${var.env}"
  }
}

resource "aws_instance" "direccionesEc2Instance" {
  count = "${var.env=="dev"||var.env=="qa" ? 1 : 0}"
  ami = "ami-0de53d8956e8dcf80"
  instance_type = "t2.micro"
  key_name = "tgr-${var.appName}"
  subnet_id = "${var.subnet[var.env]}"
  vpc_security_group_ids = ["${aws_security_group.direccionesSecurityGroup.id}"]
  iam_instance_profile = "${var.DireccionesInsProfileEc2}"
  associate_public_ip_address = true

  tags = {
    Name = "${var.appPrefix}"
    Application = "${var.appName}"
    Env = "${var.env}"
  }
  depends_on = [
    "aws_security_group.direccionesSecurityGroup"]
}

