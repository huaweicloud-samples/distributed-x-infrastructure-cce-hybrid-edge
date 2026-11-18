# ============================================================================
# 华为云 CCE 混合云部署 Terraform 配置
# ============================================================================
# 基于混合云容器部署参考架构适配
# 架构：CCE 集群 + LTS 日志收集 + KMS 密钥管理
# ============================================================================

terraform {
  required_version = ">= 1.5"

  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.70"
    }
  }
}

# ============================================================================
# Provider 配置
# ============================================================================

provider "huaweicloud" {
  region = var.region
}

# ============================================================================
# 变量定义
# ============================================================================

variable "region" {
  description = "华为云区域"
  type        = string
  default     = "cn-north-4"
}

variable "project_name" {
  description = "项目名称"
  type        = string
  default     = "cce-hybrid-edge"
}

variable "vpc_cidr" {
  description = "VPC 网段"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "子网网段"
  type        = string
  default     = "10.0.1.0/24"
}

# ============================================================================
# Layer 1: VPC 网络
# ============================================================================

resource "huaweicloud_vpc" "main" {
  name                  = "${var.project_name}-vpc"
  cidr                  = var.vpc_cidr
  enterprise_project_id = "0"
}

resource "huaweicloud_vpc_subnet" "main" {
  name       = "${var.project_name}-subnet"
  vpc_id     = huaweicloud_vpc.main.id
  cidr       = var.subnet_cidr
  gateway_ip = cidrhost(var.subnet_cidr, 1)
}

# ============================================================================
# Layer 2: CCE 集群 (通过控制台创建)
# ============================================================================
# CCE 混合集群需要特殊权限，建议通过控制台创建
# https://support.huaweicloud.com/usermanual-cce/cce_01_0108.html
# 
# 创建步骤：
# 1. 登录 CCE 控制台
# 2. 创建混合集群，选择 "Hybrid" 类型
# 3. 关联已创建的 VPC 和子网

# ============================================================================
# Layer 3: 安全组
# ============================================================================

resource "huaweicloud_networking_secgroup" "main" {
  name        = "${var.project_name}-sg"
  description = "Security group for CCE hybrid workload"
}

resource "huaweicloud_networking_secgroup_rule" "ingress_allow" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.main.id
}

resource "huaweicloud_networking_secgroup_rule" "egress_allow" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.main.id
}

# ============================================================================
# Layer 4: LTS 日志收集
# ============================================================================

resource "huaweicloud_lts_group" "main" {
  group_name  = "${var.project_name}-lts-group"
  ttl_in_days = 7
  region      = var.region
}

resource "huaweicloud_lts_stream" "main" {
  group_id    = huaweicloud_lts_group.main.id
  stream_name = "${var.project_name}-container-log"
}

# ============================================================================
# Layer 5: KMS 密钥管理
# ============================================================================

resource "huaweicloud_kms_key" "main" {
  key_alias       = "${var.project_name}-cmk"
  key_description = "KMS key for ECS Anywhere hybrid workload"
  key_algorithm   = "AES_256"
}

# ============================================================================
# Layer 6: OBS 桶（存储配置）
# ============================================================================

resource "huaweicloud_obs_bucket" "main" {
  bucket        = "${var.project_name}-config-store"
  acl           = "private"
  storage_class = "STANDARD"
}

# ============================================================================
# 输出
# ============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = huaweicloud_vpc.main.id
}

output "cluster_id" {
  description = "CCE Cluster ID (通过控制台创建)"
  value       = "请通过 CCE 控制台创建混合集群"
}

output "lts_group_id" {
  description = "LTS Group ID"
  value       = huaweicloud_lts_group.main.id
}

output "kms_key_id" {
  description = "KMS Key ID"
  value       = huaweicloud_kms_key.main.id
}

output "obs_bucket" {
  description = "OBS Bucket Name"
  value       = huaweicloud_obs_bucket.main.bucket
}
