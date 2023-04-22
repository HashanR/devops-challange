output "bastion_server_public_ip" {
  value = aws_instance.bastion_server.public_ip
}

output "alb_dns_name" {
   value = module.alb.lb_dns_name
}