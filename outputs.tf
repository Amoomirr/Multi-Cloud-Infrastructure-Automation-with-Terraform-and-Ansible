########## AWS ##############

# -------------------------------
# Output: AWS Public IPs
# -------------------------------
# This block collects the public IP addresses of all AWS EC2 instances 
# created by aws_instance.my_instance. 
# It returns a list of objects with:
# - name      -> Instance name (from tags)
# - public_ip -> Public IP assigned to the instance
# Useful for Creting ansible inventroy or SSH
# -------------------------------
output "aws_public_ips" {
  value = [
    for instance in aws_instance.my_instance : {
      name      = instance.tags.Name
      public_ip = instance.public_ip
    }
  ]
}


########## GCP ##############

# -------------------------------
# Output: GCP Public IPs
# -------------------------------
# This block collects the external (NAT) IP addresses of all GCP Compute 
# Engine instances created by google_compute_instance.vms. 
# It returns a list of objects with:
# - name      -> VM instance name
# - public_ip -> NAT IP from the network interface
# Useful for Creting ansible inventroy or SSH
# -------------------------------
output "gcp_public_ips" {
  value = [
    for instance in google_compute_instance.vms : {
      name      = instance.name
      public_ip = instance.network_interface[0].access_config[0].nat_ip
    }
  ]
}
