#AWS PROVIDER Information
provider "aws" {
      assume_role {
         role_arn  = "arn:aws:iam::${var.account_id}:role/${role_name}
         session_name = "${var.workspace_name}"
      }
    region = "us-east-1"
}

#Calling Global static_vars modules
module "global_static_vars" {
     source = "../../modules/global_vars"
}

#Defining terraform backend details to store state files on S3 bucket
terraform {
    backend "s3" {
         bucket =  "state-file-bucket"
         key    =  "state/Development/env1.tfstate"
         region = "us-east-1"
 }
}

#Accessing State files for env3-state for configuration details
data "terraform_remote_state" "env1-state" {
   backend = "s3"
   workspace = "${var.workspace_name}"
   config {
     bucket = "state-file-bucket"
     key    = "state/Development/env1.tfstate"
     region = "us-east-1"
   }
}

#Creating EC2 Instance & accessing few variables from global vars modules based on workspace selected

resource "aws_instance" "ec2-instance-dev" {
  ami           =  "${module.global_static_vars.ami-environment[terraform.workspace]}"
  instance_type =   "${module.global_static_vars.instance-env[terraform.workspace]}"
  subnet_id   =    "${module.global_static_vars.subnet-env[terraform.workspace]}"
  iam_instace_profile  = "${module.global_static_vars.role-env[terraform.workspace]}"
  tags        =  "${merge(module.global_static_vars.tags-env, map("Environment" , "Development"))}"
  vpc_security_group_ids  = "${aws_security_group.sg-dev.id}"
}
  
#Creating security group
resource "aws_security_group" "sg-dev" {
  name        = "sg-dev"
  vpc_id      =  "${module.global_static_vars.vpc-env[terraform.workspace]}"

  ingress {
    description = "https port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks =  "${module.global_static_vars.cidr-env[terraform.workspace]}"
  }

 ingress {
    description = "http port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks =  "${module.global_static_vars.cidr-env[terraform.workspace]}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 }    
