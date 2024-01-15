variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use for the provider"
  type        = string
  default     = "default"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "UbuntuInstance"
}
