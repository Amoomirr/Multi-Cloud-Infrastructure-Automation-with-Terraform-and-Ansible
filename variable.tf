########## AWS ##############

# -------------------------------
# AWS Access Key 
# -------------------------------
variable "aws_access_key" {
}

# -------------------------------
# AWS Secret Key 
# -------------------------------
variable "aws_secret_key" {
}

# -------------------------------
# AWS Region where resources will be deployed
# Default: ap-south-1 (Mumbai)
# -------------------------------
variable "aws_region" {
  default = "ap-south-1"
}

# -------------------------------
# AWS Availability Zone (specific zone inside the region)
# Default: ap-south-1a
# -------------------------------
variable "aws_az" {
  default = "ap-south-1a"
}

# -------------------------------
# AWS AMI IDs for different instance types
# Used by EC2 instances
# -------------------------------
variable "aws_amis" {
  default = {
    Ansible-Master = "ami-02d26659fd82cf299" # Ubuntu
    Ubuntu-Demo    = "ami-02d26659fd82cf299" # Ubuntu
    RedHat-Demo    = "ami-0cf8ec67f4b13b491" # RedHat
  }
}


########## GCP ##############

# -------------------------------
# GCP Region where resources will be deployed
# Default: us-central1 (Iowa)
# -------------------------------
variable "gcp_region" {
  default = "us-central1"
}

# -------------------------------
# GCP Zone (specific zone inside region)
# Default: us-central1-a
# -------------------------------
variable "gcp_zone" {
  default = "us-central1-a"
}

# -------------------------------
# GCP Project ID where resources will be created
# -------------------------------
variable "gcp_project" {
  default = "terraform-469922"
}

# -------------------------------
# GCP VM Images for deployment
# Used in google_compute_instance
# -------------------------------
variable "gcp_images" {
  default = {
    gcp-vm1 = "debian-cloud/debian-11"
    gcp-vm2 = "ubuntu-os-cloud/ubuntu-2204-lts"
  }
}

# -------------------------------
# Path to the SSH Public Key file
# Used for authenticating into VMs
# -------------------------------
variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  default     = "/home/amoomirr/Terraform-Ansible/terra-key-ansible.pub"
}

# -------------------------------
# Path to the GCP Service Account JSON key file
# Used for authentication with GCP
# (Usually provided via tfvars or environment variable)
# -------------------------------
variable "gcp_credentials_file" { 
}
