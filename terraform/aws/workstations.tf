resource "aws_instance" "habitat_workshop" {
  connection {
    user        = "${var.aws_ami_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "${var.test_server_instance_type}"
  key_name                    = "${var.aws_key_pair_name}"
  subnet_id                   = "${aws_subnet.habitat_workshop_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.habitat_workshop.id}", "${aws_security_group.habitat_supervisor.id}"]
  associate_public_ip_address = true
  count                       = "${var.count}"

  tags {
    Name          = "habitat_workshop_${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}