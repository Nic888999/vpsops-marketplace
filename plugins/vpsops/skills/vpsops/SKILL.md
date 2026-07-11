---
name: vpsops
description: Securely plan, bootstrap, deploy, relay, audit, monitor, and maintain personal VPS services. Use for first SSH access, VLESS Reality, optional relays, local proxy clients, Telegram reporting, lifecycle changes, and repeatable health checks.
---

# VPS Relay Operations

Use this skill for personal VPS administration. Adapt to the user's actual topology; a relay is optional.

## Non-negotiable rules

- Treat credentials, private keys, client subscription data, and service secrets as session-only. Never write them into the skill, scripts, reports, git, or terminal output.
- Start read-only unless the user explicitly authorizes changes. State the planned change and rollback before writing.
- Preserve one working login path. Do not disable root or password SSH until a second session has verified the new user and key.
- Back up a changed config with a timestamp, validate syntax, then reload only the affected service. Do not restart a local proxy client unless the user explicitly asks.
- Choose Ubuntu 24.04 LTS by default for a new general-purpose VPS. Use the provider image or another supported LTS only when compatibility, an existing fleet, or provider support requires it.
- Keep user-specific providers, addresses, domains, bot tokens, chat IDs, account data, and routing exceptions out of this skill. Use only runtime configuration with restrictive permissions.

## Select the architecture

First inventory the machines and desired outcome. Ask only for missing items: provider, OS, public IPv4/IPv6, current SSH user/port/auth method, cloud-console availability, intended service, and whether changes/restarts are allowed.

Choose one path:

| Situation | Apply |
| --- | --- |
| One VPS for an app, website, or private service | Bootstrap -> single-node baseline -> deploy -> audit |
| One public egress VPS | Bootstrap -> landing baseline -> deploy -> audit |
| Relay plus egress VPS | Bootstrap each -> landing baseline -> relay baseline -> path tests |
| Personal proxy, relay, or landing requested explicitly | Use the proxy default: VLESS + TCP + REALITY; use HAProxy only as an L4 relay when a separate relay is needed |
| Multiple relays or dual stack | Add independent paths, then compare stability over time |
| Existing VPS needing only a check | Run audit only; propose fixes separately |

Read [references/bootstrap.md](references/bootstrap.md) before first-access or SSH-hardening work. Read [references/topologies.md](references/topologies.md) for multi-machine work. Read [references/operations.md](references/operations.md) for the baseline, tests, and maintenance policy.

## Optional Operating Modules

Read only the relevant reference before implementing it:

| Need | Reference | Rule |
| --- | --- | --- |
| Deploy a personal VLESS + TCP + REALITY service | [references/proxy-deployment.md](references/proxy-deployment.md) | Generate runtime secrets on the server; pin Xray; test a real client before retiring a path. |
| Deliver local proxy clients and routing | [references/client-delivery.md](references/client-delivery.md) | Preserve the current client; back up first; user controls restart. |
| Daily reports, alerts, traffic, expiry tracking | [references/monitoring.md](references/monitoring.md) | Choose a stable controller; external observation is optional, not assumed. |
| Add, replace, retire, refund, or restore VPS nodes | [references/lifecycle.md](references/lifecycle.md) | Maintain a user-approved non-secret inventory and a tested rollback. |
| Prove a path works or diagnose a slowdown | [references/acceptance.md](references/acceptance.md) | Test from the real client and use measured evidence. |

## Choose The Engagement Mode

Do not assume every request starts from a blank server. If the user names an existing VPS, provides working access, asks for a check, or leaves the state unclear, start in **existing-system mode**. Use new-build mode only when the user explicitly asks to create or rebuild a server.

| Request | First action | Write permission |
| --- | --- | --- |
| New VPS or rebuild | Confirm initial access, then bootstrap | Only after explicit approval |
| Existing VPS health/security check | Read-only discovery and audit | None |
| Existing VPS change or expansion | Audit first, then present a change/rollback plan | Wait for explicit approval |
| Incident, slowdown, or outage | Collect evidence and identify the fault domain | Fix only if requested |

Read [references/existing-systems.md](references/existing-systems.md) before working on an existing VPS. In existing-system mode, discover the real OS, access posture, firewall, listeners, services, containers, timers, logs, storage, and topology before offering changes. Report the current state first, then ask whether the user wants to keep it, remediate a finding, add a VPS or relay, modify a route, or perform a planned upgrade.

## Workflow

1. **Preflight**: identify the working access route. Record non-secret facts only. Confirm the role of every machine and the user's downtime tolerance.
2. **Bootstrap**: create a named sudo user and local SSH key only if absent. Test the new access in a separate terminal before hardening. Use the provider console if SSH is unavailable.
3. **Baseline**: apply least-privilege SSH and firewall rules, automatic security updates with no automatic reboot, log rotation, journal limits, and Docker log limits where Docker is used.
4. **Deploy**: use the smallest suitable deployment. For a relay, expose only the relay listener; restrict the landing listener to trusted relay addresses. For a standalone app, expose only ports the app needs.
5. **Validate**: check service state, listening sockets, firewall, remote reachability, disk, and logs. Test an application path, not only ICMP or a public test IP.
6. **Operate**: use the audit script for read-only reviews. Monitor at several times before declaring one route superior. Keep backups and document rollback.
7. **Deliver**: when a proxy path is deployed, configure the user's requested local clients, routing, fallbacks, and acceptance tests. A server deployment is not complete until a real client path works. Then explicitly offer opt-in monitoring/reports and a non-secret inventory; do not install either without approval.

For an existing system, start at **Validate** and **Operate**, not at Bootstrap. Never rerun first-access setup, regenerate credentials, overwrite service configuration, or restart a healthy service merely because the skill was invoked in a new conversation.

## Safe change protocol

For every configuration change:

1. Capture current configuration and service state.
2. Save a timestamped backup next to the config.
3. Validate syntax before reload (`sshd -t`, service-specific config check, or container validation).
4. Reload rather than restart where possible.
5. Verify the original access path, service health, listening port, and firewall after the change.
6. State what changed, what was verified, and any residual risk.

## Update Awareness

For a substantial VPS request, identify the installed `vpsops` plugin version. When network access is available, compare it with the public marketplace manifest at `Nic888999/vpsops-marketplace`. If a newer version exists, state that an update is available before starting work and ask whether to install it.

Never force an update, and never treat a plugin update as permission to modify a VPS. If the user approves, refresh the `vpsops-marketplace` source, reinstall `vpsops@vpsops-marketplace`, then start a new task before using newly added instructions. If version checking is unavailable, proceed with the installed version and state that the update status could not be verified.

## Audit helper

Run [scripts/vps-audit.sh](scripts/vps-audit.sh) for a read-only report after a server is reachable by SSH key:

```bash
bash scripts/vps-audit.sh --host 203.0.113.10 --user admin --port 22 --identity ~/.ssh/id_ed25519
```

For password-only first access, use normal interactive `ssh` or the provider console. Do not pass a password on a command line.

## Decision guidance

- Prefer measured reliability over a single low latency result. Compare timeout rate, median, P95, loss, and real application loading across time windows.
- IPv6 is an additional path, not an unconditional replacement for IPv4. Keep both only when each route is independently reachable and stable from the client network.
- For an explicitly requested personal proxy or relay, default to VLESS + TCP + REALITY. Do not substitute VMess, Trojan, AnyTLS, or another protocol merely because it is newer or popular in a tutorial. Change protocol only for a stated compatibility, security, or measured performance reason.
- Default to daily security updates, weekly package-cache cleanup, and no automatic reboot. Schedule operating-system upgrades and major container image upgrades deliberately.
- Keep monitoring data only as long as it serves a decision. Set retention and stop temporary high-frequency probes once the comparison is complete.
- A monitoring controller cannot alert when it is itself offline. Add an independent observer only when the user has or chooses a separate machine; otherwise state this coverage gap plainly.
