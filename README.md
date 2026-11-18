# ECS Anywhere Workshop: Huawei Cloud Best Practices

![License](https://img.shields.io/badge/license-MIT--0-blue.svg)

[中文版](./README.cn.md)
![Huawei Cloud](https://img.shields.io/badge/Huawei%20Cloud-Best%20Practice-ff4d00.svg)

> Huawei Cloud Best Practice (Same-Shaped Architecture, Not Code Translation)

---

## Introduction

Hybrid cloud container deployment architecture based on Huawei Cloud CCE. Supports unified management of cloud and edge nodes for enterprise hybrid cloud deployment scenarios.

---

## Table of Contents

- [Architecture](#architecture)
- [Key Features](#key-features)
- [Cloud Services](#cloud-services)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Step-by-Step Deployment](#step-by-step-deployment)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Detailed Explanation](#detailed-explanation)
- [Dependencies](#dependencies)
- [FAQ](#faq)
- [License](#license)
- [Contact](#contact)

---

## Architecture

```
CCE Hybrid Cloud Architecture
│
├─ Cloud (Huawei Cloud)
│   ├─ CCE Cluster
│   ├─ LTS Log Collection
│   ├─ KMS Key Management
│   └─ ELB Load Balancer
│
└─ Edge Nodes (Customer Data Center)
    └─ Containerized Workloads
```

---

## Key Features

- **Hybrid Deployment**: Unified management of cloud and edge nodes
- **Elastic Scaling**: ECI for burst traffic
- **Secure & Reliable**: KMS key management + LTS log auditing
- **Resource Optimized**: Pay-as-you-go + Spot instances

---

## Cloud Services

| Reference Service | Huawei Cloud | Status |
|-------------|--------------|--------|
| ECS Anywhere | CCE Edge Nodes | 🟡 |
| ECS | CCE | 🟢 |
| CloudWatch | LTS | 🟢 |
| Secrets Manager | KMS | 🟢 |
| ALB/NLB | ELB | 🟢 |
| Object Storage | OBS | 🟢 |

---

## Prerequisites

- Huawei Cloud account (CCE, LTS, KMS enabled)
- Direct Connect or VPN (for hybrid deployment)
- kubectl configured

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/huaweicloud-samples/distributed-x-infrastructure-cce-hybrid-edge.git

# Deploy infrastructure
cd infra
terraform init
terraform apply

# Deploy workloads
kubectl apply -f deployment.yaml
```

---

## Step-by-Step Deployment

### 1. Configure Credentials

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
```

### 2. Create CCE Cluster

```bash
terraform apply
```

### 3. Deploy Applications

```bash
kubectl apply -f docs/examples/
```

---

## Usage

### Check Cluster Status

```bash
kubectl get nodes
kubectl get pods -A
```

### View Logs

```bash
lts query --group-id <group-id>
```

---

## Cleanup

```bash
terraform destroy
```

---

## Detailed Explanation

See [Architecture](./docs/architecture.md) and [Deployment Guide](./docs/deployment-guide.md)

---

## Dependencies

- [huaweicloud terraform-provider](https://registry.terraform.io/providers/huaweicloud/huaweicloud)
- Huawei Cloud CCE, LTS, KMS services

---

## FAQ

### Q: How to choose deployment mode?

A:
- Can move to cloud → CCE cloud deployment
- Low latency required → CCE edge nodes
- Budget-constrained → Hybrid deployment

### Q: How to manage edge nodes?

A: Managed through CCE console, supports node monitoring and fault recovery.

---

## License

MIT License

---

## Contact

For issues, please submit an Issue in the repository.
