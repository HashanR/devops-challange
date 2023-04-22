# DevOps-Challange

### Version Requirment 

| Technology | Version Required |
|------------|-----------------|
| Terraform  | 1.3.7 or later     |
| AWS provider for Terraform | 4.64.0 or later (from HashiCorp/aws) |

### Description

This project, I set up an infrastructure for three web servers and an application load balancer to handle traffic. I made sure to use best practices by placing the web servers in private subnets for added security. To access the web application, we could only use the application load balancer.

I also created a bastion server to allow SSH access to the web servers and used Ansible to set up Docker on the servers. Also configure the Nginx container with web page.

I have created relevent IAM polices and roles to integrate web servers Docker daemons with CloudWatch to send the logs into CloudWatch


## Architecture Diagram 

![Architecture Diagram.](https://i.ibb.co/YcncT52/infrastructure-diagram.png)

### Setup Instructions

* Clone this repository into your local machine and open terminal insde the project
* Run ``` terraform init ``` to initialize the project and download required provides
* Run ```terraform plan``` to see what are the resources will be created
* Run ```terraform apply -auto-approve``` to apply changes into cloud

#### Destroy Project

* To destroy resources run ```terraform destroy``` and it will ask confirmation and you can type ```yes``` and hit enter

#### Known isses or limitations

* There is an issue in AWS provider sometimes it stop while creating the resources due to bug in the provider and if you face same issue please re-apply.

  ![Architecture Diagram.](https://i.ibb.co/Pmc1GZm/Screenshot-from-2023-04-22-18-56-07.png)

* Due to caching sometimes when you refresh you will not get the web page from interchangeably from three servers.

  ![Architecture Diagram.](https://i.ibb.co/j6fHGnQ/Screencast-from-2023-04-22-20-12-08.gif)


#### Sources

```

https://developer.hashicorp.com/terraform/docs
https://www.terraform-best-practices.com/
https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-20-04
https://awstip.com/terraform-create-aws-ec2-instance-with-key-pair-ff541f9eec58#:~:text=Create%20a%20key%20pair%20using%20terraform&text=A%20key%20pair%20is%20used,file%20with%20the%20given%20content.
https://docs.docker.com/config/containers/logging/awslogs/

```

### Live Web Application Link 

[hub88-alb-1690307212.us-east-1.elb.amazonaws.com](hub88-alb-1690307212.us-east-1.elb.amazonaws.com)





