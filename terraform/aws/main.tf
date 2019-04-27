provider "aws" {
  region                  = "${var.aws_region}"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "~/.aws/credentials"
}

resource "random_id" "instance_id" {
  byte_length = 4
}

////////////////////////////////
// VPC 

resource "aws_vpc" "habitat_workshop_vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name          = "${var.tag_name}-vpc"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Contact     = "${var.tag_contact}"
    X-Application = "${var.tag_application}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_internet_gateway" "habitat_workshop_gateway" {
  vpc_id = "${aws_vpc.habitat_workshop_vpc.id}"

  tags {
    Name = "${var.tag_name}_habitat_workshop_gateway-${var.tag_application}"
  }
}

resource "aws_route" "habitat_workshop_internet_access" {
  route_table_id         = "${aws_vpc.habitat_workshop_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.habitat_workshop_gateway.id}"
}

resource "aws_subnet" "habitat_workshop_subnet" {
  vpc_id                  = "${aws_vpc.habitat_workshop_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag_name}_habitat_workshop_subnet-${var.tag_application}"
  }
}
////////////////////////////////
// Instance Data

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS 7 - hab*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["496323866215"]
}