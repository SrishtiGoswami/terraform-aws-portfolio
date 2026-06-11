# AWS Multi-Environment Automated Infrastructure Topology

An enterprise-grade, modular AWS infrastructure deployment managed entirely via code. This project establishes independent, production-ready networks featuring remote state isolation, tight security perimeters, and fully automated, keyless CI/CD deployments.

## Architecture Highlights
* **Zero-Cost Profile:** Fully engineered to remain 100% within the AWS Free Tier limits (utilizing modern Nitro-backed `t3.micro` instances).
* **Cryptographic Security:** Zero long-lived AWS Access Keys or Secrets stored in GitHub; authentication is brokered exclusively via **OpenID Connect (OIDC)** temporary trust policies.
* **State Isolation:** Decoupled multi-environment infrastructure backend utilizing an S3 Remote State bucket combined with a DynamoDB distributed state lock file to eliminate race conditions.

---

## Technical Stack Architecture

* **Infrastructure as Code:** Terraform (>= 1.5.0)
* **Cloud Provider:** Amazon Web Services (AWS)
* **CI/CD Automation:** GitHub Actions
* **Security & Identity:** AWS IAM OIDC Provider & Security Groups

---

## Module Breakdown & Topology

The project is structured modularly to allow immediate reuse across distinct runtime environments (`production` and `staging`).

```text
├── .github/workflows/
│   └── terraform.yml       # Automated GitHub Actions Workflow
├── modules/
│   └── vpc/
│       ├── main.tf         # VPC, Subnet, Route Table, and IGW Resources
│       ├── security.tf     # Stateful Firewalls (Security Groups)
│       ├── compute.tf      # T3.Micro Web Servers & Dynamic AMI Filtering
│       └── outputs.tf      # Modular Output Exporting
├── main.tf                 # Root Module Environment Instantiations
├── backend.tf              # Remote S3 Backend Configuration
└── outputs.tf              # Root Terminal Bubble Outputs


1. Network Layer (modules/vpc/main.tf)
Establishes an isolated network block per environment. The subnets dynamically slice IP space using the Terraform mathematical helper function:
cidrsubnet(var.vpc_cidr, 8, 1)

Production VPC: 10.0.0.0/16 ──> Public Subnet: 10.0.1.0/24

Staging VPC: 10.1.0.0/16 ──> Public Subnet: 10.1.1.0/24

2. Security Perimeter (modules/vpc/security.tf)
Implements strict stateful ingress firewalls blocking all traffic by default except explicitly authorized entry points:

Port 80 (HTTP): Public web traffic routing.

Port 443 (HTTPS): Encrypted secure layer traffic routing.

Port 22 (SSH): Secure terminal administrative control.

3. Compute Layer (modules/vpc/compute.tf)
Provisions cost-isolated compute power by querying the AWS Parameter Store for the latest verified Amazon Linux 2023 AMI image, injecting runtime shell automation script data (user_data) upon bootstrap initialization.

CI/CD GitOps Pipeline Execution
Deployments are entirely automated. When a pull request or merge to the main branch occurs, the GitHub Actions runner kicks off the following pipeline topology:

Syntax Linters (terraform fmt -check): Guarantees zero unformatted code blocks bypass repository trunk barriers.

OIDC Handshake: Establishes token trust with AWS STS to assume the deployment identity securely.

Dry-Run Analysis (terraform plan): Provides complete drift detection analysis directly inside the repository logs.

Automated Provisioning (terraform apply): Safely merges changes and mutates live cloud resources instantly on branch merges.