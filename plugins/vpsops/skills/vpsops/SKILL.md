---
name: vpsops
description: Use only when the user explicitly invokes `$vpsops` to access, audit, secure, deploy, relay, monitor, retire, or configure a real personal VPS service or its local proxy client. Do not use for VPS-related apps, panels, websites, documents, scripts, billing, research, comparisons, dashboards, or generic code.
---

# VPS Relay Operations

Use this skill for personal VPS administration. Adapt to the user's actual topology; a relay is optional.

## Invocation Boundary

This skill is explicit-use only. Do not invoke it merely because a project, title, prompt, file, or code mentions VPS, server, IP, SSH, Docker, proxy, VLESS, relay, monitoring, or networking. A VPS-related product, panel, website, document, budget, comparison, test script, or generic coding task is outside scope unless the user explicitly writes `$vpsops`.

Once explicitly invoked, apply this workflow only to the real infrastructure action the user requested. A named reference server authorizes read-only comparison only; it does not authorize copying its configuration, changing a different server, or modifying a local proxy client.

## First-Response Contract

Before running SSH or inspecting a local client, ask only for missing facts: provider and current public address; SSH user, port, and authentication method; provider console/recovery path; IPv6 state and intent; target role; any reference-host scope; allowed remote changes; and allowed local changes. Do not request passwords or private-key contents.

If TUN/proxy interception is reported, ask the user to choose exactly one access path before any local inspection: provider console/rescue terminal (recommended), user-managed temporary TUN pause/direct-network test, one-off local route, or persistent client rule. Do not reduce this to a generic promise to "find a direct connection".

## Non-negotiable rules

- Treat credentials, private keys, client subscription data, and service secrets as session-only. Never write them into the skill, scripts, reports, git, or terminal output.
- Do not ask the user to paste a password or private-key contents into chat. Use an interactive prompt, provider console, or an existing local key path. If a secret was already shared, do not repeat it and recommend rotation after a recovery path is verified.
- Start read-only unless the user explicitly authorizes changes. State the planned change and rollback before writing.
- Treat the VPS, provider panel, local files, active proxy runtime, and monitoring as separate permission scopes. Approval to deploy a VPS does not authorize local client edits, reloads, node switching, routing changes, or monitoring installation.
- If local TUN/proxy routing blocks SSH, prefer the provider console first. Require the user to choose console, manual temporary TUN pause, one-off route, or persistent client rule before recommending or changing a local access path. Do not alter a local TUN/proxy, local routing, or client configuration merely to make SSH work.
- Treat an existing VPS used as a template as evidence, not a copy source. First compare its topology and policy with the new role, then obtain explicit approval for each remote and local change.
- Treat IPv6 as a mandatory discovery field, even when the user supplies only IPv4. Before bootstrap, record exactly one state: assigned and approved for configuration/testing; assigned but declined; or unavailable/unknown and awaiting provider-panel confirmation.
- Preserve one working privileged login path. Do not disable root or password SSH until separate sessions have verified the new key, working root escalation, the reloaded SSH policy, and the provider-console recovery path.
- Back up a changed config with a timestamp, validate syntax, then reload only the affected service. Do not restart a local proxy client unless the user explicitly asks.
- Choose Ubuntu 24.04 LTS by default for a new general-purpose VPS. Use the provider image or another supported LTS only when compatibility, an existing fleet, or provider support requires it.
- Keep user-specific providers, addresses, domains, bot tokens, chat IDs, account data, and routing exceptions out of this skill. Use only runtime configuration with restrictive permissions.
- Never hard-code or guess a REALITY target. Select and validate candidates from the target VPS, then require a real-client handshake before accepting the deployment.

## Select the architecture

First inventory the machines and desired outcome. Ask only for missing items: provider, OS, public IPv4, current SSH user/port/auth method, cloud-console availability, intended service, and whether changes/restarts are allowed. Even when the user mentions only IPv4, explicitly ask whether the provider assigned IPv6 and whether the user wants it configured and tested.

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
| Deploy a personal VLESS + TCP + REALITY service | [references/proxy-deployment.md](references/proxy-deployment.md) | Scan region-appropriate targets from the VPS; generate runtime secrets on the server; pin Xray; test a real client before retiring a path. |
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

1. **Access discovery**: derive the actual SSH user, port, authentication method, power/IP state, provider firewall, and console/recovery path from the order email, provider panel, or official documentation. Do not assume `root:22`. Follow the first-response contract. If local TUN/proxy routing affects SSH, stop at an access-options decision; do not recommend or change the local client by default.
2. **Preflight**: record non-secret facts only. Confirm every machine's role, IPv4/IPv6 intent, downtime tolerance, and the exact permission scopes granted for this task. When a reference VPS is named, report a read-only comparison and ask which aspects, if any, are approved for reuse.
3. **Bootstrap**: create a named sudo user and local SSH key only if absent. In separate sessions, prove key login and actual root escalation before hardening. Keep the original privileged session open and use the provider console if SSH is unavailable.
4. **Baseline**: present a per-item approval matrix with purpose, impact, rollback, and required/optional status. Apply only the selected least-privilege SSH/firewall, security-update, and log-retention changes. Do not add optional packages, discovery-service changes, future listener rules, or tuning silently.
5. **Deploy**: show a compact native-systemd versus Docker comparison, recommend one from the host's constraints, and obtain approval before writing. For a proxy, show the REALITY candidate comparison and recommendation before configuring the chosen target.
6. **Validate**: check service state, sockets, firewall, remote reachability, disk, logs, and each approved IPv4/IPv6 path. Test an application path, not only ICMP or a public test IP. Keep server-path validation separate from local-client validation.
7. **Operate**: use the audit script for read-only reviews. Monitor at several times before declaring one route superior. Keep backups and document rollback.
8. **Deliver**: ask which device, proxy app, and core version the user uses. “You can look” grants read-only inspection only. Propose the exact nodes/groups/rules/files and rollback, and obtain separate approval before any edit, reload, activation, or switch. Do not use an active profile as a test surface without explicit approval.
9. **Handoff**: provide the exact terminal SSH command, sudo model, service/deployment mode, ports, IPv4/IPv6 results, REALITY comparison summary, client status or pending-client status, backup/rollback locations, and any remaining action. Do not call the server work complete without the SSH command. Offer monitoring and a non-secret inventory separately; do not install either without approval.

### TUN / Proxy Stop Gate

When the user reports that a local TUN/proxy blocks SSH, the first response must stop and ask the user to choose one path: provider console/rescue terminal (recommended); user-managed temporary TUN pause/direct-network test; a one-off local route; or a persistent client rule. Do not inspect local client files or runtime, run a local route command, recommend a direct rule as the preferred fix, activate a profile, or select a node until the user has chosen a path and explicitly authorized that local scope.

For an existing system, start at **Validate** and **Operate**, not at Bootstrap. Never rerun first-access setup, regenerate credentials, overwrite service configuration, or restart a healthy service merely because the skill was invoked in a new conversation.

## Safe change protocol

For every configuration change:

1. Capture current configuration and service state.
2. Restate the authorized surface and the exact files, services, rules, or runtime selections that will change. Stop on ambiguity.
3. Save a timestamped backup next to the config.
4. Validate syntax before reload (`sshd -t`, service-specific config check, or container validation).
5. Reload rather than restart where possible, only within the approved scope.
6. Verify the original access path, service health, listening port, and firewall after the change.
7. State remote-server changes and local-device changes separately, with verification and residual risk.

## Update Awareness

For a substantial VPS request, identify the installed `vpsops` plugin version. When network access is available, compare it with the public marketplace manifest at `Nic888999/vpsops-marketplace`. If a newer version exists, state that an update is available before starting work and ask whether to install it.

Never force an update, and never treat a plugin update as permission to modify a VPS. If the user approves, refresh the `vpsops-marketplace` source, reinstall `vpsops@vpsops-marketplace`, then start a new task before using newly added instructions. If version checking is unavailable, proceed with the installed version and state that the update status could not be verified.

## Audit helper

Run [scripts/vps-audit.sh](scripts/vps-audit.sh) for a read-only report after a server is reachable by SSH key:

```bash
bash scripts/vps-audit.sh --host "$VPS_IP" --user "$SSH_USER" --port "$SSH_PORT" --identity "$SSH_KEY"
```

For password-only first access, use normal interactive `ssh` or the provider console. Do not pass a password on a command line.

## Decision guidance

- Prefer measured reliability over a single low latency result. Compare timeout rate, median, P95, loss, and real application loading across time windows.
- IPv6 is an additional path, not an unconditional replacement for IPv4. Keep both only when each route is independently reachable and stable from the client network.
- For an explicitly requested personal proxy or relay, default to VLESS + TCP + REALITY. Do not substitute VMess, Trojan, AnyTLS, or another protocol merely because it is newer or popular in a tutorial. Change protocol only for a stated compatibility, security, or measured performance reason.
- For REALITY, reject fixed tutorial targets and popularity-based choices. Require TLS 1.3, ALPN `h2`, valid certificate verification, repeated reachability from the VPS, and an actual client connection. Prefer a hostname that does not redirect; treat HTTP redirect behavior as a warning and ranking penalty because it does not by itself prove whether the REALITY handshake works. A target that worked elsewhere is only a candidate.
- Default to daily security updates, weekly package-cache cleanup, and no automatic reboot. Schedule operating-system upgrades and major container image upgrades deliberately.
- Keep monitoring data only as long as it serves a decision. Set retention and stop temporary high-frequency probes once the comparison is complete.
- For quota monitoring, confirm the provider's reset timestamp/timezone and whether ingress, egress, or both directions are billed. If monitoring starts mid-cycle, seed it from the provider's current usage plus subsequent local counter deltas; never report a collection failure as zero usage.
- A monitoring controller cannot alert when it is itself offline. Add an independent observer only when the user has or chooses a separate machine; otherwise state this coverage gap plainly.
