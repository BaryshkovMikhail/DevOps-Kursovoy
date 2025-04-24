output "web_ips" {
  value = yandex_compute_instance.web[*].network_interface.0.ip_address
}

output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "alb_ip" {
  value = yandex_alb_load_balancer.web.listener[*].endpoint[*].address[*].external_ipv4_address[*].address
}