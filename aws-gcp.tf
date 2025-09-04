########## AWS ##############

# -------------------------------
# Create Key Pair for EC2 login
# -------------------------------
resource "aws_key_pair" "Key_new" {
  key_name   = "terra-key-ansible"                # Key name used in AWS
  public_key = file("terra-key-ansible.pub")      # Public key file (local .pub key) uploaded to AWS
} 

# -------------------------------
# Use Default VPC
# -------------------------------
resource "aws_default_vpc" "default" {
  # Empty block -> fetches default VPC from the AWS account
}

# -------------------------------
# Create Security Group for Ansible EC2 Instances
# -------------------------------
resource "aws_security_group" "my_ansible_security_group" {
  name        = "ansible-sg-${terraform.workspace}"          # SG name with workspace suffix
  description = "this will add a TF generated Security group"
  vpc_id      = aws_default_vpc.default.id                   # Attach SG to default VPC

  # -------- Inbound Rules --------
  ingress {
    from_port   = 22                                         # Allow SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                              # Open to all IPs (NOT recommended for prod)
    description = "SSH open"
  }
  ingress {
    from_port   = 80                                         # Allow HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }

  # -------- Outbound Rules --------
  egress {
    from_port   = 0                                          # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"                                       # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

  # Tags for identification
  tags = {
    Name        = "ansible-demo-sg-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# -------------------------------
# Launch EC2 Instances
# -------------------------------
resource "aws_instance" "my_instance" {
  for_each            = var.aws_amis                         # Create EC2s per AMI defined in variable map
  ami                 = each.value                           # Pick AMI ID from map
  instance_type       = "t2.micro"                           # Free-tier eligible instance type
  availability_zone   = var.aws_az
  key_name            = aws_key_pair.Key_new.key_name        # Attach SSH Key Pair
  security_groups     = [aws_security_group.my_ansible_security_group.name] # Attach SG
  
  depends_on          = [ aws_security_group.my_ansible_security_group, aws_key_pair.Key_new ] # Ensure dependencies created first

  # Tags for identification
  tags = {
    Name        = "${each.key}-${terraform.workspace}"
    Environment = terraform.workspace
  }
}


############ GCP ##############

# -------------------------------
# Create a Custom VPC Network
# -------------------------------
resource "google_compute_network" "vpc_network" {
  name = "ansible-network-${terraform.workspace}"             # Network name with workspace suffix
}

# -------------------------------
# Firewall Rule to Allow HTTP (port 80)
# -------------------------------
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http-${terraform.workspace}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]                               # Open to all (public)
  target_tags   = ["ansible", terraform.workspace]            # Firewall applies only to instances with these tags
}

# -------------------------------
# Firewall Rule to Allow SSH (port 22)
# -------------------------------
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh-${terraform.workspace}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]                               # Open to all (for demo only, lock down in prod)
}

# -------------------------------
# Launch GCP VM Instances
# -------------------------------
resource "google_compute_instance" "vms" {
  for_each     = var.gcp_images                               # Create multiple VMs per image defined in variable map
  name         = "${each.key}-${terraform.workspace}"         # VM name with workspace suffix
  machine_type = "e2-micro"                                   # Free-tier eligible VM
  zone         = var.gcp_zone

  # Boot disk with provided image
  boot_disk {
    initialize_params {
      image = each.value
    }
  }

  # Attach VM to custom VPC + enable external IP
  network_interface {
    network       = google_compute_network.vpc_network.name
    access_config {}                                          # Allocates external IP
  }

  # Add SSH key for VM login
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"      # Uploads public key for SSH access
  }

  # Tags for firewall rules
  tags = ["ansible", terraform.workspace]
}
