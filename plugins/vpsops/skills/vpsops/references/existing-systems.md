# Existing Systems Mode

## Default Behavior

Treat an existing VPS as unknown until inspected. Begin read-only, even when the user provides a prior design description. The live system is the source of truth.

Do not create users, change SSH, replace a container, change firewall rules, rotate credentials, restart services, or run a setup script during discovery.

## Discovery Checklist

Collect and summarize, without exposing secrets:

- OS, kernel, uptime, load, memory, swap, disk, and inode use;
- SSH effective policy, firewall state, intended open listeners, recent authentication failures;
- failed units, enabled services, Docker containers/images, service health, and restart history;
- automatic security updates, log rotation, journal size, package updates, and scheduled timers;
- for a relay topology: identify each node's role, reachable address family, relay target, and independently reachable fallback;
- application-level reachability and recent error logs relevant to the user's report.

Use `scripts/vps-audit.sh` where key-based SSH access is available. For password-only or provider-console access, use equivalent read-only commands interactively.

## Report Before Changes

Return a compact report in this order:

1. current topology and running services;
2. health and capacity;
3. security posture and noteworthy logs;
4. maintenance/retention status;
5. findings ranked by urgency;
6. next options: no change, fix a finding, add a machine/relay, alter routing, upgrade, or diagnose a symptom.

If no fault is found, state `OK` and list only remaining monitoring or test gaps. Do not create work merely because a new conversation began.

## Controlled Changes

When the user selects a change, form a narrow plan from the discovered state. Preserve existing configuration, back it up with a timestamp, validate the proposed replacement, and retain the prior access path until verification succeeds.

An optional inventory file may record non-secret facts such as provider, role, OS, public addresses, service names, renewal date, and last audit date. Create or update it only with explicit user approval. Never store passwords, private keys, UUIDs, client links, or tokens.
