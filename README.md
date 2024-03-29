# Kubernetes Cluster in AWS EC2 with Terraform and Ansible
By [@EligioMerino](https://github.com/eligiomerino), 2024.

This is a Terraform project that builds an old-fashioned Kubernetes cluster in AWS - i.e. using EC2 virtual machines. I built this project for fun but using the best-practices I learnt over my +25 years of IT experience. If are looking to learn Kubernetes setup through `kubeadm`, and how to deploy AWS infrastructure through Terraform, and how to configure Kubernetes machines using Ansible, then this PoC project could be of help (: 

I got this PoC written in Terraform "modules" and Asible Playbooks in order to properly structure and re-use code whenever possible. 

* **VPC module:** It fully builds and configures the VPC where the EC2 machines will be deployed. 
    
    > **NOTE 1:** The reason I am using a public subnet in this PoC is to save costs since using private subnets to deploy the Kubernetes machines would requiere to setup and configure at least one NAT Gateway, which could rocket up your AWS invoice up to the sky - whenever you have a Free Tier account or not.

    > **NOTE 2:** As mentioned above, I am using a public subnet with and Internet Gateway and Route Tables to manage the network traffic and securing all ingress traffic to client's public IP. In a Production environment with ful public access, the configuration should go to have an Nginx Reverse Proxy Server in a public subnet and put the whole Kubernetes cluster into a private subnet - which would need an AWS NAT Gateway. AWS ASG/ALB could be also used to span multi-AZ the HA Kubernetes critical components such as the Control Plane and the ETCD server.
    
* **Public Subnet module:** Builds the subnet where the Kubernetes machines are going to be deployed.

* **Internet Gateway module:** It deploys an IGW for public inboud/outbound connection from/to the public subnet.

* **Route Table module:** It deploys, associates and configures the route rules for the public subnet.

* **EC2 module:** It first gets client's public IP to later get it added in the AWS Security Group for the Kubernetes EC2 cluster. Also, it configures the SG with all mandatory ports for Kubernetes connections, service discovery, along with the ports for WeaveNet CNI plugin. I also added a data block to dynamically get the AMI for Ubuntu Server v20.x LTS using arm64 as it is cheaper than amd64 platform. In the end, this module deploys, builds and configures a Control Plane node with two Worker nodes. The build is done through a CloudInit script and the configuration is done trough Ansible.

The `cloudinit-k8s-common-components.yaml` file contains all the common settings for all the Kubernetes machines. The `playbook-install.yaml` file will tell Ansible how to configure Control Plane and how to configure the Worker nodes. It will also deploys and configures the WeaveNet CNI plugin along with establishing the connection between the Worker nodes and the Contol Plane machine.
