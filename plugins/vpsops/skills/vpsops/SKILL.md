---
name: vpsops
description: Securely plan, bootstrap, deploy, relay, audit, and maintain personal VPS servers. Use for first SSH access with password or key, Ubuntu server hardening, Docker services, single-node deployments, relay-plus-egress topologies, IPv4/IPv6 evaluation, safe updates, log rotation, and repeatable VPS health checks.
---

# VPS Relay Operations

Use this skill for personal VPS administration. Adapt to the user's actual topology; a relay is optional.

## Non-negotiable rules

- Treat credentials, private keys, client subscription data, and service secrets as session-only. Never write them into the skill, scripts, reports, git, or terminal output.
- Start read-only unless the user explicitly authorizes changes. State the planned change and rollback before writing.
- Preserve one working login path. Do not disable root or password SSH until a second session has verified the new user and key.
- Back up a changed config with a timestamp, validate syntax, then reload only the affected service. Do not restart a local proxy client unless the user explicitly asks.
- Choose Ubuntu 24.04 LTS by default for a new general-purpose VPS. Use the provider image or another supported LTS only when compatibility, an existing fleet, or provider support requires it.

## Select the architecture

First inventory the machines and desired outcome. Ask only for missing items: provider, OS, public IPv4/IPv6, current SSH user/port/auth method, cloud-console availability, intended service, and whether changes/restarts are allowed.

Choose one path:

| Situation | Apply |
| --- | --- |
| One VPS for an app, website, or private service | Bootstrap -> single-node baseline -> deploy -> audit |
| One public egress VPS | Bootstrap -> landing baseline -> deploy -> audit |
| Relay plus egress VPS | Bootstrap each -> landing baseline -> relay baseline -> path tests |
| Multiple relays or dual stack | Add independent paths, then compare stability over time |
| Existing VPS needing only a check | Run audit only; propose fixes separately |

Read [references/bootstrap.md](references/bootstrap.md) before first-access or SSH-hardening work. Read [references/topologies.md](references/topologies.md) for multi-machine work. Read [references/operations.md](references/operations.md) for the baseline, tests, and maintenance policy.

## Workflow

1. **Preflight**: identify the working access route. Record non-secret facts only. Confirm the role of every machine and the user's downtime tolerance.
2. **Bootstrap**: create a named sudo user and local SSH key only if absent. Test the new access in a separate terminal before hardening. Use the provider console if SSH is unavailable.
3. **Baseline**: apply least-privilege SSH and firewall rules, automatic security updates with no automatic reboot, log rotation, journal limits, and Docker log limits where Docker is used.
4. **Deploy**: use the smallest suitable deployment. For a relay, expose only the relay listener; restrict the landing listener to trusted relay addresses. For a standalone app, expose only ports the app needs.
5. **Validate**: check service state, listening sockets, firewall, remote reachability, disk, and logs. Test an application path, not only ICMP or a public test IP.
6. **Operate**: use the audit script for read-only reviews. Monitor at several times before declaring one route superior. Keep backups and document rollback.

## Safe change protocol

For every configuration change:

1. Capture current configuration and service state.
2. Save a timestamped backup next to the config.
3. Validate syntax before reload (`sshd -t`, service-specific config check, or container validation).
4. Reload rather than restart where possible.
5. Verify the original access path, service health, listening port, and firewall after the change.
6. State what changed, what was verified, and any residual risk.

## Audit helper

Run [scripts/vps-audit.sh](scripts/vps-audit.sh) for a read-only report after a server is reachable by SSH key:

```bash
bash scripts/vps-audit.sh --host 203.0.113.10 --user admin --port 22 --identity ~/.ssh/id_ed25519
```

For password-only first access, use normal interactive `ssh` or the provider console. Do not pass a password on a command line.

## Decision guidance

- Prefer measured reliability over a single low latency result. Compare timeout rate, median, P95, loss, and real application loading across time windows.
- IPv6 is an additional path, not an unconditional replacement for IPv4. Keep both only when each route is independently reachable and stable from the client network.
- Default to daily security updates, weekly package-cache cleanup, and no automatic reboot. Schedule operating-system upgrades and major container image upgrades deliberately.
- Keep monitoring data only as long as it serves a decision. Set retention and stop temporary high-frequency probes once the comparison is complete.
