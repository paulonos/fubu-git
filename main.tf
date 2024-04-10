

data "aws_key_pair" "devops-keypair.pem" {
  key_name           = "devops-keypair.pem"
  include_public_key = true

}
resource "aws_instance" "fubu" {
  ami           = var.ami[count.index]
  instance_type = var.instance_type
  key_name      = "devops-keypair.pem"
  vpc_security_group_ids = [aws_security_group.SG.id]
  
  count = 2
  

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum update -y",
  #     "sudo yum install httpd -y",
  #     "sudo systemctl start httpd",
  #     "sudo systemctl enable httpd",

  #   ]

  #   connection {
  #     type = "ssh"
  #     user = "ec2_user"
  #     private_key = data.aws_key_pair.Dev_KP_OH
  #     host = self.public_ip
  #   }
    
  # }
              



  lifecycle {
    create_before_destroy = true

    # prevent_destroy = true

  }
  tags = {
    Name            = "Instance-${count.index}"           # Assign a unique name based on the instance key
    Ansible-Control-Server = "True"                     # Tag for the control server
    Ansible-Managed-Server = "True"                     # Tag for the managed server
  }
  # tags = {
  #   Name = "Ansible-server"
  # }

}
resource "aws_security_group" "SG" {

  name = "terraform-webserverSG"


  ingress {
    description = "Allow SSH"

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }



  ingress {
    description = "Allow httpd"

    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }




  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}



output "instance_ip_addr" {
  value       = [for instance in aws_instance.fubu : instance.private_ip]
  description = "The private IP address of the main server instance."
}

