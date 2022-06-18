# Jenkins Server

variable "server_name" {
  default = "jenkins-server"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0fa49cc9dc8d62c84" # Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
}

variable "monitoring" {
  type    = bool
  default = true
}

# Security Group

variable "security_group_name" {
  default = "jenkins-server-sg"
}

# IAM Role

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = "jenkins_server_role"
}
