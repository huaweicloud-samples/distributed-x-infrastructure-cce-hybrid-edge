# ECS Anywhere 工作坊：华为云最佳实践

![License](https://img.shields.io/badge/license-MIT--0-blue.svg)

[English](./README.md)
![Huawei Cloud](https://img.shields.io/badge/华为云-最佳实践-ff4d00.svg)

> 华为云最佳实践（同构架构，非代码平移）

---

## 简介

基于华为云 CCE 实现的混合云容器部署架构。支持云端和边缘节点统一管理，适用于现代企业混合云部署场景。

---

## 目录

- [架构图](#架构图)
- [方案亮点](#方案亮点)
- [涉及云服务](#涉及云服务)
- [前置条件](#前置条件)
- [快速开始](#快速开始)
- [分步部署](#分步部署)
- [使用方法](#使用方法)
- [清理资源](#清理资源)
- [详细说明](#详细说明)
- [参考实现](#参考实现)
- [FAQ](#faq)
- [许可证](#许可证)
- [联系方式](#联系方式)

---

## 架构图

```
CCE 混合云架构
│
├─ 云端 (华为云)
│   ├─ CCE 集群
│   ├─ LTS 日志收集
│   ├─ KMS 密钥管理
│   └─ ELB 负载均衡
│
└─ 边缘节点 (客户数据中心)
    └─ 容器化工作负载
```

---

## 方案亮点

- **混合部署**: 云端和边缘节点统一管理
- **弹性伸缩**: 支持突发流量使用 ECI
- **安全可靠**: KMS 密钥管理 + LTS 日志审计
- **资源优化**: 按量付费 + 竞价实例

---

## 涉及云服务

| 参照服务 | 华为云 | 状态 |
|---------|--------|------|
| ECS Anywhere | CCE 边缘节点 | 🟡 |
| ECS | CCE | 🟢 |
| CloudWatch | LTS | 🟢 |
| Secrets Manager | KMS | 🟢 |
| ALB/NLB | ELB | 🟢 |
| 对象存储 | OBS | 🟢 |

---

## 前置条件

- 华为云账号（已开通 CCE、LTS、KMS 服务）
- 专线或 VPN 连接（混合部署）
- kubectl 配置完成

---

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/huaweicloud-samples/distributed-x-infrastructure-cce-hybrid-edge.git

# 部署基础架构
cd infra
terraform init
terraform apply

# 部署工作负载
kubectl apply -f deployment.yaml
```

---

## 分步部署

### 1. 配置凭证

```bash
export HW_ACCESS_KEY="your-access-key"
export HW_SECRET_KEY="your-secret-key"
```

### 2. 创建 CCE 集群

```bash
terraform apply
```

### 3. 部署应用

```bash
kubectl apply -f docs/examples/
```

---

## 使用方法

### 查看集群状态

```bash
kubectl get nodes
kubectl get pods -A
```

### 查看日志

```bash
lts query --group-id <group-id>
```

---

## 清理资源

```bash
terraform destroy
```

---

## 详细说明

详见 [架构说明](./docs/architecture.md) 和 [部署指南](./docs/deployment-guide.md)

---

## 参考实现

- [huaweicloud terraform-provider](https://registry.terraform.io/providers/huaweicloud/huaweicloud)
- 华为云 CCE, LTS, KMS 服务

---

## FAQ

### Q: 如何选择部署模式？

A: 
- 可上云 → CCE 云端部署
- 低延迟 → CCE 边缘节点
- 预算受限 → 混合部署

### Q: 边缘节点如何管理？

A: 通过 CCE 控制台统一管理，支持节点监控和故障恢复。

---

## 许可证

MIT License

---

## 联系方式

如有问题，请在仓库中提交 Issue。
