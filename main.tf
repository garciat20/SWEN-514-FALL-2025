# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "TMG_AWS_KEY_NV"   # SSH key pair name for EC2 instance access
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
   user_data     = "${file("wp_install.sh")}"
   vpc_security_group_ids = [aws_security_group.allow_traffic.id]
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec3"
   }
}

#update security to allow traffic coming into the system via HTTP only (port 80)
resource "aws_security_group" "allow_traffic" {
    name          = "example-3-sec-group"
    description   = "example-3"

    ingress {
      protocol   = "tcp"
      from_port     = 80
      to_port       = 80
      cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      cidr_blocks = ["0.0.0.0/0"]
      protocol = -1

    }
    tags = {
    Name = "terraform_activity_one"
  }
}