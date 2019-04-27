output "workstation_public_ips" {
  value = "${join(",", aws_instance.habitat_workshop.*.public_ip)}"
}
