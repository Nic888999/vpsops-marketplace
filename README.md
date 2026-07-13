# VPSOps

[English](#english) | [简体中文](#简体中文)

## 简体中文

VPSOps 是一个面向 Codex 的个人 VPS 运维技能。它用于安全地完成新 VPS 初始化、现有服务器核查、Docker 服务部署、可选中转拓扑、本地代理客户端交付、监控日报与日常维护。

### 适用范围

- 首次 SSH 登录、密钥与账号加固
- 从服务商邮件/面板确认真实 SSH 端口、账号、防火墙和恢复入口
- 单台 VPS 或中转加落地的部署设计
- Docker、日志轮转、自动安全更新与基础健康检查
- VLESS + TCP + REALITY 的个人代理部署
- 在目标 VPS 上动态筛选并验证 REALITY 目标站
- 主动确认 IPv6，并分别验收 IPv4/IPv6
- Clash Verge、sing-box 等本地客户端的路由与备用方案
- 本地代理配置使用独立授权，最终交付可直接使用的 SSH 命令
- 按服务商账期和计费方向统计流量、到期日、状态日报和告警
- 已运行 VPS 的只读审计、变更与退役

### 设计原则

- 默认先核实、后修改；任何变更都需要用户明确授权。
- 不把密码、私钥、订阅链接、Token、IP 或个人规则写入仓库。
- 保留可用登录路径，先备份并校验，再重载相关服务。
- 中转是可选架构；单台 VPS 同样可以完整使用本技能。
- 以真实客户端体验、稳定性和可回退性为准，而不是单次延迟。

### 安装

在 Codex 中添加此 GitHub Marketplace 后安装 `vpsops`。安装完成后新建一个任务，并直接说明目标，例如：

可以把下面这句话直接发送给 Codex：

```text
请从 GitHub 仓库 https://github.com/Nic888999/vpsops-marketplace 添加 VPSOps Marketplace，并安装和启用 vpsops 插件。安装完成后告诉我版本号，并提醒我新建一个任务来使用它。
```

- `Use $vpsops to audit my existing VPS without changing it.`
- `Use $vpsops to securely bootstrap my new VPS.`

安装、启用或更新插件后，应新建任务，以确保 Codex 载入最新技能内容。

### 安全与隐私

此仓库不应包含任何真实凭据、私钥、服务器地址、Bot Token、订阅链接或个人分流规则。请阅读 [SECURITY.md](SECURITY.md) 后再提交 Issue 或贡献。

### 版本

版本遵循语义化版本：修复使用补丁版本，新增兼容功能使用次版本，不兼容变更使用主版本。完整记录见 [CHANGELOG.md](CHANGELOG.md)。

## English

VPSOps is a Codex skill for safe personal VPS operations: first access, audits, deployments, optional relay topologies, local proxy clients, monitoring, and maintenance.

It is designed around explicit approval, least privilege, recoverable changes, and keeping credentials out of source control. See the Chinese section above for the full current usage guide.

## License

This project is licensed under the [MIT License](LICENSE).
