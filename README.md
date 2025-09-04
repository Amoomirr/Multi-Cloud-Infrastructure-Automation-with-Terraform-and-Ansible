# 🌍 Multi-Cloud Infrastructure Automation with Terraform and Ansible

This project demonstrates how to provision and manage a **multi-cloud lab environment** across **AWS** and **GCP** using **Terraform** for Infrastructure as Code (IaC) and **Ansible** for Configuration Management.

It provisions compute resources on both clouds, sets up networking, and uses Ansible to configure applications (like Nginx), automate updates, and monitor server health.

---

## 🚀 Project Overview

- **AWS Setup**  
  - Default VPC with Security Group (SSH/HTTP).  
  - Terraform-generated Key Pair.  
  - 3 EC2 instances (Ubuntu & RedHat).  
  - Public IPs exported for Ansible inventory.  

- **GCP Setup**  
  - Custom VPC with firewall rules (SSH/HTTP).  
  - 2 Compute Engine VMs (Debian & Ubuntu).  
  - SSH keys injected for secure login.  
  - Public IPs exported for Ansible usage.  

- **Ansible Integration**  
  - Central Ansible Master (Ubuntu EC2).  
  - Playbooks for package updates & Nginx installation.  
  - Ad-hoc commands for service control and monitoring.  

---

## 🛠️ Key Skills Demonstrated

- **Terraform (IaC):** Multi-cloud automation with reproducible environments (Dev/Stage/Prod).  
- **AWS (EC2, VPC, SG):** Secure compute resources with environment-based tagging.  
- **GCP (Compute, VPC, Firewall):** Provisioned networked VMs with SSH access.  
- **Ansible:** Configuration management across heterogeneous servers.  

---

## 📂 Project Structure

```

ansible-multi-env/
│── aws.tf
│── gcp.tf
│── variables.tf
│── providers.tf
│── outputs.tf
│
│── playbook/
│   ├── update.yml
│   └── nginx-install.yml
│
│── inventory/
│   ├── dev.ini
│   ├── stage.ini
│   └── prod.ini
│
└── .ssh/
└── terra-key-ansible.pem

````

## ⚙️ Terraform Core Commands

```bash
terraform init     # Initialize working directory
terraform plan     # Show execution plan
terraform apply    # Provision infrastructure
terraform destroy  # Tear down resources
````

---
## 🔍 Verification

### ✅ Terraform Outputs

Public IPs of AWS & GCP instances are exported and used as Ansible inventory.

<img width="1898" height="990" alt="outputs" src="https://github.com/user-attachments/assets/56045424-015e-4d0f-b2f3-e8b49e752852" />


### ✅ AWS Dashboard

<img width="1911" height="687" alt="AWS-Dashboard" src="https://github.com/user-attachments/assets/6ca096fa-5ee8-4ebb-8dc4-e2a03e887af7" />


### ✅ GCP Dashboard

<img width="1813" height="777" alt="GCP-Dashboard" src="https://github.com/user-attachments/assets/8e718b4a-19a2-4409-9af1-12cbcebd9f33" />

---
## 📦 Ansible Setup

Install Ansible on the Master Node:

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
ansible --version
```

---

## ▶️ Example Playbooks

* **Update Packages (update.yml)**
* **Install & Start Nginx (nginx-install.yml)**

Run playbooks:

```bash
ansible-playbook -i inventory/stage.ini playbook/update.yml
ansible-playbook -i inventory/stage.ini playbook/nginx-install.yml
```

<img width="957" height="1006" alt="nginx-install" src="https://github.com/user-attachments/assets/d8b47aff-58db-4c56-87f8-bef5cc31a77c" />

<img width="1688" height="1010" alt="ansible-nginx-install" src="https://github.com/user-attachments/assets/b82dd0a6-1cf3-46f8-b3c1-64d1a627891a" />

---

### ✅ Nginx Deployment

* Access Nginx via AWS/GCP public IPs.

```bash
http://<AWS_Public_IP>
http://<GCP_Public_IP>
```
<img width="1805" height="846" alt="gcp-nginx" src="https://github.com/user-attachments/assets/67ef2ee3-8361-445c-808a-c974460d552a" />

<!-<img width="1782" height="930" alt="NGINX-AWS" src="https://github.com/user-attachments/assets/f3e8dc25-7c5b-4896-b2a7-488345b8c2bc" />

---

### ✅ Service Control (Start/Stop Nginx)

```bash
ansible -i inventory/stage.ini server3 -a "sudo systemctl stop nginx"
ansible -i inventory/stage.ini server3 -a "sudo systemctl start nginx"
ansible -i inventory/stage.ini server3 -a "sudo systemctl status nginx"
```
<img width="1907" height="1007" alt="nginx stopped " src="https://github.com/user-attachments/assets/ad616f2a-379d-4271-89a7-94b2a905ded1" />

---

### ✅ Monitoring Disk Utilization

```bash
ansible -i inventory/stage.ini ansible_servers -a "df -h"
```
<img width="1131" height="759" alt="df-h" src="https://github.com/user-attachments/assets/1980107a-5883-45ae-97ff-d955ecb75e60" />

---

## ✅ Conclusion

This project demonstrates:

* Automated provisioning of multi-cloud infra (AWS + GCP) with **Terraform**.
* Seamless **Ansible** integration for configuration management.
* Cross-platform orchestration (Ubuntu, Debian, RedHat).
* Environment isolation via Terraform workspaces (Dev/Stage/Prod).
* Practical foundation for **hybrid-cloud DevOps workflows**.

---

👨‍💻 **Author:** Mohammed Amir
📌 *Showcasing DevOps | Cloud | IaC Projects*

```
