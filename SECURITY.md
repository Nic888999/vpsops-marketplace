# Security Policy

## Supported versions

Security fixes are applied to the latest released version on the `main` branch.

## Reporting a vulnerability

Do not open a public issue for a vulnerability that includes credentials, private keys, server addresses, service configuration, logs, or an exploitable deployment detail.

Use GitHub Private Vulnerability Reporting for this repository. If that option is unavailable, contact the repository owner through the GitHub profile without including secrets in public content.

Reports should include a minimal reproduction, affected version, impact, and safe remediation guidance. Remove all personal infrastructure data before submitting.

## Credential handling

VPSOps must never store real passwords, SSH private keys, subscription links, access tokens, bot tokens, chat IDs, server IP addresses, or personal routing rules in this repository. Treat accidental disclosure as a security incident and rotate the exposed secret immediately.
