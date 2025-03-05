
# Install Git
# Installs the Git version control system on your EC2 instance.

sudo yum install git -y

# Install Terraform
# Installs Terraform, a tool for managing infrastructure as code.

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# Create SSH keypair
# Generates a new RSA SSH keypair for secure connections.

ssh-keygen -t rsa -b 2048 -f assignments

# Run Terraform in network and webserver (init, plan, apply)
# Executes Terraform commands to initialize, plan, and apply infrastructure configurations.
# Terraform commands go here

# SSH into webserver
# Connects to the web server using the created SSH keypair.

chmod 600 assignments
ssh -i assignments public IP

# Inside SSH, configure AWS credentials
# Configures AWS CLI with the necessary access credentials.
mkdir ~/.aws
sudo nano ~/.aws/credentials

# Install Docker
# Installs Docker, a platform for running containerized applications.

sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install MySQL
# Installs the MySQL client to interact with MySQL databases.

sudo yum -y install mysql

# Exit SSH
# Exits from the SSH session with the webserver.

exit

# Perform GitHub Actions
# Reconnects to the server and sets up GitHub repository for actions.

ssh -i assignments public IP

# Install Git and clone the repository
# Installs Git and clones a repository from GitHub.

sudo yum -y install git
git clone https://github.com/Sdhakal24/clo835_assignment02_portable_tech.git

# Login to AWS ECR
# Authenticates Docker to push/pull images from AWS ECR (Elastic Container Registry).
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 274232764676.dkr.ecr.us-east-1.amazonaws.com

# Pull Docker images from ECR
# Downloads the Flask and SQL Docker images from the specified ECR repositories.

docker pull 274232764676.dkr.ecr.us-east-1.amazonaws.com/flaskapp:latest
docker pull 274232764676.dkr.ecr.us-east-1.amazonaws.com/sql:latest

# Tag Docker images
# Tags the pulled Docker images locally for easier use.

docker tag 274232764676.dkr.ecr.us-east-1.amazonaws.com/flaskapp:latest flaskapp:latest
docker tag 274232764676.dkr.ecr.us-east-1.amazonaws.com/sql:latest sql:latest

# Go to Kubernetes directory
# Navigates to the directory containing Kubernetes configuration files.

cd cloassig/app/Kubernetes

# Install Kind
# Installs Kind, a tool for running Kubernetes clusters in Docker containers.

curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Install kubectl
# Installs kubectl, the command-line tool for interacting with Kubernetes clusters.

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Create Kind cluster
# Creates a new Kubernetes cluster using Kind with a custom configuration file.

kind create cluster --config=/home/ec2-user/clo835_assignment02_portable_tech/app/kubernetes/kind-cluster.yml

# Load Docker images into Kind
# Loads the Docker images into the Kind cluster for Kubernetes deployment.

kind load docker-image flaskapp:latest --name kind
kind load docker-image sql:latest --name kind

# Kubernetes Cluster Info
# Displays the cluster information for the currently active Kubernetes cluster.

kubectl cluster-info

# Deploy Namespace
# Creates a new namespace in Kubernetes to isolate MySQL and web app resources.

kubectl apply -f /home/ec2-user/clo835_assignment02_portable_tech/app/kubernetes/namespace.yml

# Deploy MySQL and Webapp
# Deploys MySQL and web application pods and services in the Kubernetes cluster.

kubectl apply -f mysql-pod.yml
kubectl apply -f mysql-service.yml

kubectl get pods -n mysql-ns

kubectl apply -f webapp-pod.yml

kubectl get pods -n webapp-ns

#Port Forwarding

kubectl port-forward -n webapp pod/webapp-pod 8080:8080 --address 0.0.0.0 & 


# Test Webapp
# Tests the web application by making a request to the local address.

curl localhost:8080  # (public IP:8080)


# View Webapp Logs
# Views the logs of the web application pod for debugging purposes.

kubectl logs pods webapp -n webapp-ns

# Create ReplicaSet for 2 MySQL and Webapp Pods
# Creates and applies ReplicaSets to ensure 2 replicas of each pod.

kubectl apply -f mysql-replicaset.yml
kubectl apply -f webapp-replicaset.yml

# Create ReplicaSet for 2 (Updated)
# Creates and applies a deployment for the MySQL and web application.
kubectl apply -f mysql-deployment.yml
kubectl apply -f webapp-deployment.yml

# Expose Webapp Service
# Exposes the web application using a Kubernetes service configuration.

sudo nano webapp-service.yml
kubectl apply -f webapp-service.yml

# Test Webapp service
# Verifies the exposed service is accessible from the public IP on port 30000.
curl localhost:30000  # (public IP:30000)

# Checking Pods
# Checks the status of MySQL and webapp pods in their respective namespaces.
kubectl get pods -n mysql-ns
kubectl get pods -n webapp-ns

# Update Webapp Version
# Applies a new version of the web application in Kubernetes and verifies it.
kubectl apply -f webapp-updated-version.yml
curl localhost:30000  # (public IP:30000)
