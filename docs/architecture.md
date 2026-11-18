# 架构说明：CCE 混合云部署

## 概述

基于华为云 CCE 实现的混合云容器部署架构，支持云端和边缘节点统一管理。

---

## 核心架构

```
CCE 混合云架构
│
├─ 云端 (华为云)
│   ├─ CCE 集群
│   ├─ LTS 日志收集
│   ├─ KMS 密钥管理
│   └─ ELB 负载均衡
│
├─ 边缘节点 (客户数据中心)
│   ├─ 纳管服务器
│   └─ 容器化工作负载
│
└─ 网络连接
    └─ 专线 / VPN
```

---

## 部署模式

### 1. 云端部署模式

所有工作负载运行在 CCE 集群上：

- 优点：统一管理、弹性伸缩
- 适用：可上云的工作负载

### 2. 边缘节点模式

工作负载分布在云端和边缘：

- 优点：低延迟、数据本地化
- 适用：IoT、边缘计算场景

### 3. 混合部署模式

核心服务在云端，边缘处理突发流量：

- 优点：按量弹性、按需伸缩
- 适用：波峰波谷明显的工作负载

---

## 组件说明

### CCE 集群

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
---
apiVersion: v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:latest
        ports:
        - containerPort: 80
```

### LTS 日志收集

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: lts-config
data:
  config.yaml: |
    log_config:
      collectors:
        - container_stdout
        - container_stderr
      sinks:
        - type: LTS
          region: cn-north-4
```

### KMS 密钥管理

```
1. 创建密钥
2. 授予 CCE 服务账户访问权限
3. 在 Pod 中通过 Secret 引用
```

---

## 网络架构

### 专线连接

```
客户数据中心 ── 专线 ── 华为云 VPC
     │
     └─ 边缘节点 ──┘
```

### VPN 连接

```
客户数据中心 ── VPN ── 华为云 VPC
     │
     └─ 边缘节点 ──┘
```

---

## 费用说明

| 资源 | 结算方式 | 说明 |
|------|---------|------|
| CCE 集群 | 不单独收费 | 控制平面不收费 |
| CCE 节点 | 按量/包年 | 按实际使用 |
| LTS | 按量 | 按日志量结算 |
| ECI | 按量 | 按 vCPU/内存/运行时长 |
| 专线/VPN | 包年 | 带宽费 |
