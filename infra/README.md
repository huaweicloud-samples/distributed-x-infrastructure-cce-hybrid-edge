# 基础设施配置

本目录包含华为云 CCE 混合云部署的 Terraform 配置文件。

## 文件说明

| 文件 | 说明 |
|------|------|
| main.tf | 主配置文件，包含所有资源定义 |

## 资源清单

| 资源类型 | 数量 | 说明 |
|----------|------|------|
| VPC | 1 | 虚拟私有云 |
| VPC Subnet | 1 | 子网 |
| CCE Cluster | 1 | 混合云容器集群 |
| Security Group | 1 | 安全组 |
| Security Group Rules | 2 | 入站/出站规则 |
| LTS Group | 1 | 日志收集组 |
| LTS Stream | 1 | 日志流 |
| KMS Key | 1 | 密钥管理 |
| OBS Bucket | 1 | 对象存储 |

## 使用方法

```bash
# 初始化
terraform init

# 验证配置
terraform validate

# 预览变更
terraform plan

# 部署资源（需确认费用）
terraform apply

# 销毁资源
terraform destroy
```

## 费用说明

| 资源 | 规格 | 结算方式 |
|------|------|----------|
| CCE 集群 | cce.s1.small | 按规格 |
| VPC | 默认 | 不单独收费 |
| 安全组 | 默认 | 不单独收费 |
| LTS | - | 按日志量结算 |
| KMS | AES_256 | 按密钥数量 |
| OBS | 标准存储 | 按存储量结算 |
