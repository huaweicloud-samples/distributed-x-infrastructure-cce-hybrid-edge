# 部署指南：CCE 混合云部署

## 概述

本文档说明如何在华为云 CCE 上实现混合云容器部署。

---

## 前置条件

1. 华为云账号（已开通 CCE、LTS、KMS 服务）
- 专线或 VPN 连接（用于混合部署）
- 目标服务器已安装 Docker

---

## 部署步骤

### 步骤 1: 创建 CCE 集群

```bash
# 使用 terraform 或控制台
terraform init
terraform apply
```

### 步骤 2: 配置 LTS 日志收集

```bash
# 安装 LTS 采集器
helm install lts-collector lts-chart/

# 配置日志采集规则
kubectl apply -f lts-config.yaml
```

### 步骤 3: 配置密钥管理

```bash
# 创建密钥
kms create-key --key-spec AES_256

# 创建 Secret
kubectl create secret generic my-secret \
  --from-literal=username=admin \
  --from-literal=password=xxx
```

### 步骤 4: 部署工作负载

```bash
# 部署应用
kubectl apply -f deployment.yaml

# 查看状态
kubectl get pods
```

---

## 混合部署（边缘节点）

### 步骤 1: 安装边缘节点代理

```bash
# 在边缘服务器上安装
wget https://huaweicloud-agent-installer.sh
chmod +x huaweicloud-agent-installer.sh
sudo ./huaweicloud-agent-installer.sh --cluster-id <cluster-id>
```

### 步骤 2: 纳管边缘节点

```bash
# 确认节点加入
kubectl get nodes
```

### 步骤 3: 部署到边缘节点

```yaml
# 使用 nodeSelector 调度到边缘节点
apiVersion: v1
kind: Deployment
metadata:
  name: edge-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: edge
  template:
    spec:
      nodeSelector:
        node-type: edge
      containers:
      - name: edge
        image: nginx:latest
```

---

## 部署后操作

### 1. 配置健康检查

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 10

livenessProbe:
  httpGet:
    path: /health
    port: 80
  initialDelaySeconds: 15
  periodSeconds: 20
```

### 2. 配置弹性伸缩

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## 清理资源

```bash
# 删除工作负载
kubectl delete -f deployment.yaml

# 删除 CCE 集群
terraform destroy

# 删除 LTS 日志组
lts delete-group --group-id <group-id>
```

---

## 费用监控

### 设置告警

1. 登录费用中心
2. 设置预算告警
3. 配置通知方式

### 查看费用

```
费用中心 -> 费用分析 -> CCE/LTS/KMS
```
