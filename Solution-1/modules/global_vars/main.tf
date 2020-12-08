#Global Variable Declaration which are called based on workspace defination

variable "ami-environment" {
   default = {
       Development = "ami id for dev"
       ITCA        = "ami id for itca"
       Prod        = "ami id for prod"
     }
}

variable "instance-env" {
default = {
       Development = "instance type for dev"
       ITCA        = "instance type for itca"
       Prod        = "instance type for prod"
     }
}

variable "subnet-env" {
default = {
       Development = "Subnet id dev"
       ITCA        = "subnet id for itca"
       Prod        = "instance id for prod"
     }
}

variable "role-env" {
default = {
       Development = "role arn dev"
       ITCA        = "role arn itca"
       Prod        = "role arn prod"
     }
}

variable "tags-env" {
default = {
       Name = Server
       Application = APP
       }
}

variable "env-cidr" {
default = {
       Development = "cidr dev"
       ITCA        = "cidr itca"
       Prod        = "cidr prod"
     }
}

variable "vpc-env" {
default = {
       Development = "vpc id dev"
       ITCA        = "vpc id itca"
       Prod        = "vpc id prod"
     }
}
