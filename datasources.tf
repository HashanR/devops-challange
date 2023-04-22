data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "template_file" "ansible_web_hosts" {
  count           = length(module.vpc.private_subnets)
  template   = file("${path.root}/templates/ansible_hosts.tpl")
  depends_on = [aws_instance.web_server]

  vars = {
    node_name    = aws_instance.web_server.*.tags[count.index]["Name"]
    ansible_user = var.ssh_user
    ip           = element(aws_instance.web_server.*.private_ip, count.index)
  }
}


data "template_file" "ansible_skeleton" {
  template = file("${path.root}/templates/ansible_skeleton.tpl")

  vars = {
    web_hosts_def = join("", data.template_file.ansible_web_hosts.*.rendered)
  }
}