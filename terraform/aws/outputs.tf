output "workstation_public_ips" {
  value = ["${aws_instance.habitat_workshop.*.public_ip}"]
}
