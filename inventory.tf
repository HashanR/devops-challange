
resource "local_file" "ansible_inventory" {
  depends_on = [data.template_file.ansible_skeleton]

  content  = data.template_file.ansible_skeleton.rendered
  filename = "${path.root}/ansible/inventory"
}


resource "null_resource" "cp_ansible" {
  depends_on = [
    aws_instance.bastion_server
  ]

  triggers = {
    always_run = timestamp()
  }

  provisioner "file" {
    source      = "${path.root}/ansible"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion_server.public_ip
      user        = var.ssh_user
      private_key = file(var.key_file)
      insecure    = true
    }
  }
}

resource "null_resource" "ansible_run" {
  depends_on = [
    null_resource.cp_ansible,
    aws_instance.web_server,
    aws_instance.bastion_server,
  ]

    
  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = aws_instance.bastion_server.public_ip
    user        = var.ssh_user
    private_key = file(var.key_file)
    insecure    = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'ssh is up...'",
      "sleep 360 && ansible-playbook -i /home/ubuntu/ansible/inventory /home/ubuntu/ansible/playbook.yml ",
    ]
  }
}
