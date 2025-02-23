# variables.tf
variable "ec2_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"  # You can provide a default value or leave it empty for input during `terraform apply`
}

variable "image_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID or leave it empty to provide it at runtime
}


# variables related to dynamoDB
variable "prefix" {
  type    = string
  default = "stewart2-6-tf"
}
variable "createdByTerraform" {
  type    = string
  default = "Managed by Terraform - Stewart"
}
variable "key_pair" {
  type    = string
  default = "stewart2-6-keypair"
}